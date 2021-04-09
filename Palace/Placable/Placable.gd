extends Node2D
# The thing we click on to select
# and the thing that appears on the cursor
# The other items (waterfalls, etc.) derive from it
export(PackedScene) var this_scene;
onready var object_cursor = get_node("/root/Palace/EditorObjectOnCursor")
onready var cursor_sprite = object_cursor.get_node("AnimatedSprite")

func _ready():
	print(self.name, ', this_scene, ', this_scene)

func item_clicked(event):
	if event is InputEvent and event.is_action_pressed("click"):
		_on_click()

func _on_Button_pressed():
	_on_click()

func _on_click():
	object_cursor.current_item = this_scene
	cursor_sprite.frames = $AnimatedSprite.frames
	cursor_sprite.animation = $AnimatedSprite.animation
	cursor_sprite.playing = true

func _on_Button_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()

func _on_Button_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()
