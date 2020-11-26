extends Node

# the status of a quest can be in these states:
enum {
	NOT_STARTED,
	IN_PROGRESS,
	FINISHED,  # The quest is dinished, but we haven't talked to the quest giver so it still appears
	DONE,  # The quest doesn't appear anywhere anymore
}
var quests = []

# Called when the node enters the scene tree for the first time.
func _ready():
	quests = Game.retrieve_from_json_file("res://Quests/quests.json")
	for quest_id in quests:
		quests[quest_id].status = NOT_STARTED  # should be NOT_STARTED
		quests[quest_id].id = quest_id
		quests[quest_id].counter = 0
		if quests[quest_id].type == "find_sentences":
			quests[quest_id].counter_max = len(quests[quest_id].parameters[0])
	init_with_initial_state()

func init_with_initial_state():
	pass
#	quests['find_sentences_in_chaiyaphum'].status = FINISHED

func start_quest(quest_id):
	print('we start the quest ', quest_id)
	quests[quest_id].status = IN_PROGRESS
	if quests[quest_id].type == "find_sentences":
		# We count the sentences that were already found
		for id_of_sentence_to_find in quests[quest_id].parameters[0]:
			if id_of_sentence_to_find in Game.seen_sentences or id_of_sentence_to_find in Game.known_sentences:
				quests[quest_id].parameters[1].append(id_of_sentence_to_find)
				quests[quest_id].counter += 1
	elif quests[quest_id].type == "implant_source_with_this_word_i_gave_you":
		# We create the word next to the player
		var word_id = quests[quest_id].parameters[0]
		var new_word = load("res://Lexical/Word/Spell.tscn").instance()
		new_word.id = word_id
		new_word.word = Game.words[str(word_id)]
		new_word.can_move = true
		new_word.position = Game.player.position
		Game.current_scene.get_node("YSort").add_child(new_word)		
	update_quests_display()

func update_quests_display():
	Game.player.update_quest_display()

func update_find_sentences_quests(sentence_id):
	for quest_id in quests:
		var quest = quests[quest_id]
		if quest.status == IN_PROGRESS and quest.type == "find_sentences":
			if sentence_id in quest.parameters[0]:
				if not sentence_id in quest.parameters[1]:
					quest.parameters[1].append(sentence_id)
					quest.counter += 1
					if quest.counter >= quest.counter_max:
						quest.status = FINISHED
					update_quests_display()

func update_implant_source_with_this_word_quests(source_name):
	for quest_id in quests:
		var quest = quests[quest_id]
		if quest.status == IN_PROGRESS and quest.type in ["implant_source_with_this_word", "implant_source_with_this_word_i_gave_you"]:
			if source_name == quest.parameters[1]:
				quest.status = FINISHED
				update_quests_display()

func get_finished_quest_ids():
	var finished_quest_ids = []
	for quest_id in quests:
		if quests[quest_id].status == FINISHED:
			finished_quest_ids.append(quest_id)
	return finished_quest_ids

func get_not_started_quest_ids():
	var not_started_quest_ids = []
	for quest_id in quests:
		if quests[quest_id].status == NOT_STARTED:
			not_started_quest_ids.append(quest_id)
	return not_started_quest_ids

func mark_quest_as_done(quest_id):
	quests[quest_id].status = DONE
	print('quests[quest_id].status', quests[quest_id].status)
	update_quests_display()

func load_game(quests_data):
	for quest in quests:
		quests[quest].status = quests_data[quest]
	update_quests_display()

func save_game():
	var quests_data = {}
	for quest in quests:
		quests_data[quest] = quests[quest].status
	return quests_data
