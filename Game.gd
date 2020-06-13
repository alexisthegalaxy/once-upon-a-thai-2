extends Node

var change_color = false
var goal_color = null
var words
var current_scene = null
var known_words = []
var player = null

func knows_word(word) -> bool:
	return word["id"] in known_words

func retrieve_words_from_json():
	var data_file = File.new()
	if data_file.open("res://Lexical/Word/words.json", File.READ) != OK:
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
	words = retrieve_words_from_json()

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
	var ref = weakref(current_scene)
	print('ref', ref)
	if ref.get_ref():
		print('current_scene', current_scene)
		current_scene.free()
	# Load and instance the new scene.
	current_scene = ResourceLoader.load(to_map_name).instance()
	for child in current_scene.get_children():
		print('--- ', child.get_name())
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

func _on_word_area_entered(id) -> void:
	known_words.append(id)

func _on_changelight_entered(color) -> void:
	change_color = true
	goal_color = color
