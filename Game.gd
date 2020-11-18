extends Node

var change_color = false
var last_goal_color = Color(1, 1, 1, 1)
var goal_color = null

var words = []
var sentences = []
var letters = []

# The following are a list of IDs
#var known_words = [343, 345, 207, 82] 
var known_words = []
#var known_sentences = [196, 197, 198, 199]  # we know the translation. Does not contain seen_sentences.
#var known_sentences = [196, 197, 198]  # we know the translation. Does not contain seen_sentences.
var known_sentences = []  # we know the translation. Does not contain seen_sentences.
var seen_sentences = []  # we don't know the translation
#var known_letters = [0, 11, 13, 21]  # list of IDs
#var known_letters = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40]  # list of IDs
var known_letters = []  # list of IDs
#var known_letters = [0, 11, 13, 21, 28]  # five letters
var collected_letters = []

var exit_screen = false
var current_dialog = null

var this_letter_world_has_letters = []  # a list of letter ids
var letters_we_look_for = []  # a list of letters
var looking_for_letter__node = null
var player_position_on_overworld = null  # used when coming back from Letter World
var player_last_overworld_map_visited = "res://Maps/Chaiyaphum.tscn"
var current_map_name = "res://Maps/Chaiyaphum.tscn"

# This is the letters yaai asks us to fetch the first time we come in the Memory Palace
#var initial_letters = [0, 6, 9, 11, 13, 17, 19, 21, 28, 36]  # outdated
var initial_letters = [11, 13, 28, 0, 21]

# when players comes near a npc/word/letter/sentence,
# it get appended to current_focus, and gets removed when leaving
var current_focus = []
var space_bar_to_interact = null
var current_scene = null
var active_test = null
var player = null
var player_name = "Alexis"
var player_sprite_path = "res://Npcs/sprites/main_A.png"
var can_move = true
var can_read_thai = false

var hp = 5.0
var max_hp = 5.0
var rng = RandomNumberGenerator.new()
var is_frozen = false

var should_start_test_when_back_from_MP = [
	null,  # "res://Test/TestGuessMeaning.tscn"
	null,  # word_id
]

func is_overworld_frozen():
	return active_test or current_dialog or is_frozen

func dialog_press_f_to_see_it(learnt_item):
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	var lines = []
	if learnt_item == "sentence":
		lines = ["Press F to open your notebook and see your sentences."]
	if learnt_item == "letter":
		lines = ["Press F to open your alphabet and see your letters."]
	if learnt_item == "word":
		lines = ["Press F to open your dictionary and see your words"]
	Game.current_dialog.init_dialog(lines, null, null, null, null)
	current_scene.add_child(Game.current_dialog)

func a_word_is_learnt():
	# Whenever a word is learnt, we run this function
	if len(Game.known_words) == 10:
		Game.pop_victory_screen()
#	if not Events.events.has_learnt_four_first_words:
#		if 343 in Game.known_words and 345 in Game.known_words and 207 in Game.known_words and 82 in Game.known_words:
#			Events.events.has_learnt_four_first_words = true
#			if not Game.current_focus:
#				Game.current_focus.append(Game.current_scene.get_node("YSort").get_node("NPCs").get_node("Yaai"))
#			Events.npc_walks_to([[player.position]])
			

func discovers_sentence(sentence_id, is_translated):
	Game.can_move = false
	var sentence_discovery = load("res://Lexical/Sentence/SentenceDiscovery.tscn").instance()
	sentence_discovery.sentence_discovery_init(sentence_id, is_translated)
	current_scene.add_child(sentence_discovery)

func clear_deleted_focuses():
	for object in current_focus:
		if not is_instance_valid(object):
			current_focus.erase(object)

func gains_focus(target):
	clear_deleted_focuses()
	# When the player enters into the interat zone of npc/word/letter
	if not space_bar_to_interact:
		space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
		current_scene.add_child(space_bar_to_interact)
	current_focus.append(target)

func reset_focus():
	clear_deleted_focuses()
	if current_focus:
		if not space_bar_to_interact:
			space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
			Game.current_scene.add_child(space_bar_to_interact)

func lose_focus(target):
	clear_deleted_focuses()
	while target in current_focus:
		current_focus.erase(target)
	if not current_focus:
		if space_bar_to_interact:
			space_bar_to_interact.queue_free()
			space_bar_to_interact = null
		else:
			print('weird')
			print('we called loses_focus while space_bar_to_interact was already deleted.')
#	current_focus = null

func learn_letter(letter):
	Game.known_letters.append(letter["id"])
	if looking_for_letter__node:
		looking_for_letter__node.update_label_text()
	Game.player.arrow.arrow_letter_update()
	var knows_the_letters_from_the_beginning = true
	for letter_id_from_the_beginning in initial_letters:
		if not letter_id_from_the_beginning in known_letters:
			knows_the_letters_from_the_beginning = false
	if not Events.events["has_finished_the_letter_world_the_first_time"] and knows_the_letters_from_the_beginning:
		Events.events["has_finished_the_letter_world_the_first_time"] = true
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		var dialog = [
			"[Name]!",
			"[Name], do you hear me?",
			"You have found all the letters you needed for now - you can come back amongst us now.",
			"To leave this world, press the F key.",
		]
		Game.current_dialog.init_dialog(dialog, null, null, false, "Yaai")
		player.stop_walking()
		Game.current_scene.add_child(Game.current_dialog)

func add_random_letter_to_letters_to_look_for():
	var random_letter = Game.letters[str(rng.randi() % Game.letters.size())]
	if not random_letter in letters_we_look_for:
		letters_we_look_for.append(random_letter)
		if looking_for_letter__node:
			looking_for_letter__node.init(letters_we_look_for)
		else:
			looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
			looking_for_letter__node.init(letters_we_look_for)
			Game.current_scene.add_child(looking_for_letter__node)

func set_hp(_hp) -> void:
	player.set_hp(_hp)

func knows_word(word) -> bool:
	return word["id"] in known_words

func knows_letter(letter) -> bool:
	return letter["id"] in known_letters

func print_known_sentences() -> void:
	print('print_known_sentences')
	for known_sentence_id in known_sentences:
		var sentence = sentences[str(known_sentence_id)]
		print(sentence["th"])
	print('print_seen_sentences')
	for seen_sentence_id in seen_sentences:
		var sentence = sentences[str(seen_sentence_id)]
		print(sentence["th"])
	print("\n")

func pop_victory_screen() -> void:
	var VictoryScreen = load("res://UI/Victory.tscn")
	var victory_screen = VictoryScreen.instance()
	var world = current_scene
	world.add_child(victory_screen)

func retrieve_from_json_file(file):
	var data_file = File.new()
	if data_file.open(file, File.READ) != OK:
		print('problem opening the json file!!!')
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print('problem parsing the json file!!!')
		return
	return data_parse.result

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	words = retrieve_from_json_file("res://Lexical/Word/words.json")
	sentences = retrieve_from_json_file("res://Lexical/Sentence/sentences.json")
	letters = retrieve_from_json_file("res://Lexical/Letter/letters.json")
	print('letters')
	

func _input(_event):
	if _event.is_action_pressed("ui_cancel"):
		if not exit_screen:
			exit_screen = load("res://UI/ExitAreYouSure.tscn").instance()
#			get_tree().current_scene.add_child(exit_screen)
			Game.current_scene.add_child(exit_screen)
		else:
			if is_instance_valid(exit_screen):
				exit_screen.stay()

func _process(delta):
	OS.set_window_title("Once upon a Thai | fps: " + str(Engine.get_frames_per_second()))
	if change_color:
		var canvas_modulate = current_scene.get_node("Lights").get_node("CanvasModulate")
		var direction = Vector3(goal_color.r, goal_color.g, goal_color.b) - Vector3(canvas_modulate.color.r, canvas_modulate.color.g, canvas_modulate.color.b)
		if direction.length() < 0.0001:
			change_color = false
		canvas_modulate.color.r += delta * direction.x
		canvas_modulate.color.g += delta * direction.y
		canvas_modulate.color.b += delta * direction.z

func update_letters_to_look_for_if_necesssary(to_map_name):
	if not Events.events["can_see_the_looking_for_letter_banner"]:
		return
	if not Events.events["has_been_in_the_letter_world"]:
		return
	if not "LexicalWorld" in to_map_name:
		return
	Game.player.arrow.arrow_letter_update()
	looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
	
	var letters_we_look_for_here = []
	if this_letter_world_has_letters:
		for letter_id in this_letter_world_has_letters:
			var letter = letters[str(letter_id)]
			if letter in letters_we_look_for:
				letters_we_look_for_here.append(letter)
	else:
		letters_we_look_for_here = letters_we_look_for
	looking_for_letter__node.init(letters_we_look_for_here)
	current_scene.add_child(looking_for_letter__node)

func start_test_when_back_from_MP():
	if should_start_test_when_back_from_MP[0]:
		var word_id = should_start_test_when_back_from_MP[1]
		print('Game should_start_test_when_back_from_MP', should_start_test_when_back_from_MP)
		var new_word = load("res://Lexical/Word/Spell.tscn").instance()
		new_word.id = word_id
		new_word.word = Game.words[str(word_id)]
		new_word.can_move = true
		new_word.position = player.position
		print('current_scene', current_scene)
		current_scene.get_node("YSort").add_child(new_word)
		start_test(
			should_start_test_when_back_from_MP[0],
			word_id,
			new_word
		)

#func _clear_non_singletons():
	# TODO: Use it in _deferred_goto_scene before we set a new child
#	for child in get_tree().get_root().get_children():
#		print('--- child name ', child.get_name())
#		if not child.get_name() in ["Game", "Events", "SoundPlayer"]:
#			child.queue_free()

func _deferred_goto_scene(to_map_name, to_x, to_y):
	can_move = true
	if not "LexicalWorld" in current_map_name:
		if player:
			player_position_on_overworld = player.position
			player_last_overworld_map_visited = current_map_name
	var previous_map_name = current_map_name
	current_map_name = to_map_name
	
	var player_velocity = Vector2.ZERO
	if player:
		player_velocity = player.velocity
	
	if current_scene:
		current_scene.queue_free()
	
	assert(to_map_name != "")
	current_scene = ResourceLoader.load(to_map_name).instance()
#	print('current_scene', current_scene.get_children())
#	if len(current_scene.get_children()) == 3:
#		SoundPlayer.play_thai("ตุ๊กแก")
#		yield(get_tree().create_timer(1.0), "timeout")
	
#	var b = current_scene.get_node("YSort")
#	SoundPlayer.play_thai("คน")
#	yield(get_tree().create_timer(1.0), "timeout")
#	var children = b.get_children()  # crash only on production!
	
#	SoundPlayer.play_thai("คน")
#	yield(get_tree().create_timer(1.0), "timeout")
	
	# Problem here!!!!
	# It looks like it fails to find .get_node("Player")
	# inside current_scene.get_node("YSort")!
#	var c = current_scene.get_node("YSort").get_node("Player")
	
#	SoundPlayer.play_thai("ไทย")
#	yield(get_tree().create_timer(1.0), "timeout")
#	SoundPlayer.play_thai("เป็น")
#	yield(get_tree().create_timer(1.0), "timeout")

	player = current_scene.get_node("YSort").get_node("Player")
	player.position = Vector2(to_x, to_y)
	player.velocity = player_velocity
	SoundPlayer.start_music_upon_entering_map(to_map_name)
	
#	SoundPlayer.play_thai("ไทย")
#	yield(get_tree().create_timer(1.0), "timeout")
#	SoundPlayer.play_thai("เป็น")
#	yield(get_tree().create_timer(1.0), "timeout")
	
	# If we add a yield(get_tree().create_timer(1.0), "timeout")
	# between the next two lines, we get a crash. Why?
	for child in get_tree().get_root().get_children():
		if not child.get_name() in ["Game", "Events", "SoundPlayer"]:
			child.queue_free()
#	for child in get_tree().get_root().get_children():
#		print('--- child name ', child.get_name())
#	print('get_tree().get_root().get_children()', get_tree().get_root().get_children())  # ViewPort
	get_tree().get_root().add_child(current_scene)
	
#	for child in get_tree().get_root().get_children():
#		print('--- child name ', child.get_name())
#		if child.get_name() == "PlayerHouse":
#			SoundPlayer.play_thai("เป็น")
#			yield(get_tree().create_timer(1.0), "timeout")
#	print('get_tree().get_root().get_children()', get_tree().get_root().get_children())  # ViewPort
#	get_tree().set_current_scene(current_scene)

#	SoundPlayer.play_thai("เป็น")
#	yield(get_tree().create_timer(1.0), "timeout")
	
	update_letters_to_look_for_if_necesssary(to_map_name)

	if "LexicalWorld" in previous_map_name and not "LexicalWorld" in current_map_name:
		current_scene.get_node("Lights").get_node("CanvasModulate").color = Game.last_goal_color
		start_test_when_back_from_MP()
	
#	SoundPlayer.play_thai("ดี")
#	yield(get_tree().create_timer(1.0), "timeout")
	
func _on_InteractBox_body_entered(_player, npc) -> void:
	_player._on_InteractBox_body_entered(npc)

func _on_InteractBox_body_exited(_player, npc) -> void:
	_player._on_InteractBox_body_exited(npc)

func add_sentence(sentence_id, x, y):
	known_sentences.append(sentence_id)
	var floaty = load("res://UI/Floaty.tscn").instance()
	floaty.text = "new sentence added!"
	floaty.position.x = x
	floaty.position.y = y
	current_scene.add_child(floaty)

func _on_sentence_area_entered(sentence_id, x, y) -> void:
	if not sentence_id in known_sentences:
		add_sentence(sentence_id, x, y)

func _on_changelight_entered(color) -> void:
	change_color = true
	goal_color = color
	last_goal_color = color

func start_test(test_scene, entity_id, over_entity) -> void:
	"""
	entity either refers to a letter or to a word
	(maybe to a phrase too, later on?)
	"""
	var test = load(test_scene).instance()
	self.add_child(test)
	active_test = test
	test.init(entity_id, over_entity)
	if looking_for_letter__node:
		looking_for_letter__node.get_node("Node2D").hide()
