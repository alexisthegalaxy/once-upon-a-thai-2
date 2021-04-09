extends TabContainer

onready var object_cursor = get_node("/root/Palace/EditorObjectOnCursor")

func _on_TabContainer_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()

func _on_TabContainer_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()
