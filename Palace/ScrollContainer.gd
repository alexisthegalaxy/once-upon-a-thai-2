extends ScrollContainer

onready var object_cursor = get_node("/root/Palace/EditorObjectOnCursor")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("mouse_entered", self, "mouse_enter")
	connect("mouse_exited", self, "mouse_leave")

func mouse_enter():
	object_cursor.can_place = false
	object_cursor.hide()

func mouse_leave():
	object_cursor.can_place = true
	object_cursor.show()
