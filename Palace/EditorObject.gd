extends Node2D

var can_place = true
onready var level = get_node("/root/Palace/Level/YSort")
var current_item

func _process(delta):
	global_position = get_global_mouse_position()
	if current_item != null and can_place and Input.is_action_just_pressed("click"):
		var new_item = current_item.instance()
		level.add_child(new_item)
		new_item.global_position = get_global_mouse_position() 
