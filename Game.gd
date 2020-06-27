extends Node

var change_color = false
var goal_color = null

var words = []
var sentences = []
var letters = []

var known_words = []
var known_sentences = []  # we know the translation
var seen_sentences = []  # we don't know the translation
var known_letters = []

var letters_we_look_for = []  # a list of letters
var looking_for_letter__node = null

var current_focus = null  # if player is around a npc/word/letter, this becomes it
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

func dialog_press_e_to_see_it(learnt_item):
	var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
	var lines = []
	if learnt_item == "sentence":
		lines = ["Press F to open your notebook and see your sentences."]
	if learnt_item == "letter":
		lines = ["Press F to open your alphabet and see your letters."]
	if learnt_item == "word":
		lines = ["Press F to open your dictionary and see your words"]
	print('lines ', lines)
	ui_dialog.init(lines, player, null, null, null)
	get_tree().current_scene.add_child(ui_dialog)

func discovers_sentence(sentence_id, is_translated):
	var sentence_discovery = load("res://Lexical/Sentence/SentenceDiscovery.tscn").instance()
	sentence_discovery.init(sentence_id, is_translated)
	get_tree().current_scene.add_child(sentence_discovery)
	
func gains_focus(target):
	# When the player enters into the interat zone of npc/word/letter
	if not space_bar_to_interact:
		space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
		get_tree().current_scene.add_child(space_bar_to_interact)
	current_focus = target

func loses_focus(target):
	if target == current_focus:
		if space_bar_to_interact:
			space_bar_to_interact.queue_free()
			space_bar_to_interact = null
	else:
		print('current_focus ', current_focus)
	current_focus = null

func learn_letter(letter):
	Game.known_letters.append(letter["id"])
	if looking_for_letter__node:
		looking_for_letter__node.update_label_text()

func add_random_letter_to_letters_to_look_for():
	var random_letter = Game.letters[str(rng.randi() % Game.letters.size())]
	if not random_letter in letters_we_look_for:
		print('random_letter ', random_letter)
		letters_we_look_for.append(random_letter)
		if looking_for_letter__node:
			looking_for_letter__node.init(letters_we_look_for)
		else:
			looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
			looking_for_letter__node.init(letters_we_look_for)
			get_tree().current_scene.add_child(looking_for_letter__node)

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

func pop_victory_screen() -> void:
	var VictoryScreen = load("res://UI/Victory.tscn")
	var victory_screen = VictoryScreen.instance()
	var world = get_tree().current_scene
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

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if change_color:
		var canvas_modulate = get_tree().current_scene.get_node("Lights").get_node("CanvasModulate")
		canvas_modulate.color.r = (canvas_modulate.color.r * 99 + goal_color.r) / 100
		canvas_modulate.color.g = (canvas_modulate.color.g * 99 + goal_color.g) / 100
		canvas_modulate.color.b = (canvas_modulate.color.b * 99 + goal_color.b) / 100

func _on_teleport_signal(to_map_name, to_x, to_y) -> void:
	call_deferred("_deferred_goto_scene", to_map_name, to_x, to_y)

func update_letters_to_look_for_if_necesssary(to_map_name):
	if "LexicalWorld" in to_map_name:
		looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
		looking_for_letter__node.init(letters_we_look_for)
		get_tree().current_scene.add_child(looking_for_letter__node)

func _deferred_goto_scene(to_map_name, to_x, to_y):
	var player_velocity = Vector2.ZERO
	if player:
		player_velocity = player.velocity
	if current_scene:
		print('current_scene')
		print(current_scene)
		current_scene.free()
	assert(to_map_name != "")
	current_scene = ResourceLoader.load(to_map_name).instance()
	player = current_scene.get_node("YSort").get_node("Player")
	player.position = Vector2(to_x, to_y)
	player.velocity = player_velocity
	print('player.velocity', player.velocity)
	SoundPlayer.start_music_upon_entering_map(to_map_name)
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	update_letters_to_look_for_if_necesssary(to_map_name)
	
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
	get_tree().current_scene.add_child(floaty)

func _on_sentence_area_entered(sentence_id, x, y) -> void:
	if not sentence_id in known_sentences:
		add_sentence(sentence_id, x, y)

func _on_changelight_entered(color) -> void:
	change_color = true
	goal_color = color

func start_test(test_scene, entity_id, over_entity) -> void:
	"""
	entity either refers to a letter or to a word
	(maybe to a phrase too, later on?)
	"""
	var test = load(test_scene).instance()
	self.add_child(test)
	active_test = test
	test.init(entity_id, over_entity)
