extends Node


var change_color = false
var goal_color = null

var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


#func init_map():
#	var player = get_tree().current_scene.get_node("YSort").get_node("Player")
#	for npc in get_tree().get_nodes_in_group("npcs"):
#		var npc_interact_box = npc.get_node("InteractBox")
#		npc_interact_box.connect("body_entered", player, "_on_InteractBox_body_entered", [npc])
#		npc_interact_box.connect("body_exited", player, "_on_InteractBox_body_exited", [npc])
#	for changelight in get_tree().get_nodes_in_group("changelights"):
#		changelight.connect("body_entered", self, "_on_changelight_body_entered", [changelight.color])


func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if change_color:
		var canvas_modulate = get_tree().current_scene.get_node("Lights").get_node("CanvasModulate")
		canvas_modulate.color.r = (canvas_modulate.color.r * 99 + goal_color.r) / 100
		canvas_modulate.color.g = (canvas_modulate.color.g * 99 + goal_color.g) / 100
		canvas_modulate.color.b = (canvas_modulate.color.b * 99 + goal_color.b) / 100


func _on_changelight_body_entered(_player, color):
	change_color = true
	goal_color = color

func _on_teleport_signal(to_map_name, to_x, to_y) -> void:
#	var _e = get_tree().change_scene(to_map_name)
#	var player = get_tree().current_scene.get_node("YSort").get_node("Player")
#	var to_map = get_tree().get_root().find_node("res://Maps/PlayerHouse.tscn")
#	player.position.x = to_x
#	player.position.y = to_y
	call_deferred("_deferred_goto_scene", to_map_name, to_x, to_y)

func _deferred_goto_scene(to_map_name, to_x, to_y):
	# It is now safe to remove the current scene
	current_scene.free()
	# Load and instance the new scene.
	current_scene = ResourceLoader.load(to_map_name).instance()
	for child in current_scene.get_children():
		print('--- ', child.get_name())
	current_scene.get_node("YSort").get_node("Player").position.x = to_x
	current_scene.get_node("YSort").get_node("Player").position.y = to_y
#	current_scene.Ysort.Player.position.x = to_x
#	current_scene.Ysort.Player.position.y = to_y
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

func _on_InteractBox_body_entered(player, npc) -> void:
	player._on_InteractBox_body_entered(npc)

func _on_InteractBox_body_exited(player, npc) -> void:
	player._on_InteractBox_body_exited(npc)
	
