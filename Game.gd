extends Node

var change_color = false
var goal_color = null

var words = []
var sentences = []
var letters = []

var known_words = []
var known_sentences = []
var known_letters = []

var current_focus = null  # if player is around a npc/word/letter, this becomes it
var current_scene = null
var active_test = null
var player = null

var can_move = true

var hp = 5.0
var max_hp = 5.0

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
#	var _e = get_tree().change_scene(to_map_name)
#	var player = get_tree().current_scene.get_node("YSort").get_node("Player")
#	var to_map = get_tree().get_root().find_node("res://Maps/PlayerHouse.tscn")
#	player.position.x = to_x
#	player.position.y = to_y
	call_deferred("_deferred_goto_scene", to_map_name, to_x, to_y)

func _deferred_goto_scene(to_map_name, to_x, to_y):
	# It is now safe to remove the current scene
	# var ref = weakref(current_scene)
	current_scene.free()
	# Load and instance the new scene.
	assert(to_map_name != "")
	current_scene = ResourceLoader.load(to_map_name).instance()
#	for child in current_scene.get_children():
#		print('--- ', child.get_name())
	player = current_scene.get_node("YSort").get_node("Player")
	player.position.x = to_x
	player.position.y = to_y
#	current_scene.Ysort.Player.position.x = to_x
#	current_scene.Ysort.Player.position.y = to_y
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

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
