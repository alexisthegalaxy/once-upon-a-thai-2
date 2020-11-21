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
	print('questsˀ')
	for quest_id in quests:
		print('------------------------')
		print(quests[quest_id])

func start_quest(quest_id):
	print('we start the quest ', quest_id)
	quests[quest_id].status = IN_PROGRESS
	update_quests_display()

func update_quests_display():
	Game.player.update_quest_display()

func update_find_sentences_quests(sentence_id):
	print('sentence_id', sentence_id)
	for quest_id in quests:
		var quest = quests[quest_id]
		if quest.status == IN_PROGRESS and quest.type == "find_sentences":
			if sentence_id in quest.parameters[0]:
				print('this sentence is part of the quest!')
				if sentence_id in quest.parameters[1]:
					print('this sentence was found already')
				else:
					print('great! this sentence wasnt found already!')
					quest.parameters[1].append(sentence_id)
					quest.counter += 1
					if quest.counter >= quest.counter_max:
						quest.status = FINISHED
					update_quests_display()
