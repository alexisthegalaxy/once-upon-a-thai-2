extends Node2D
# The thing we click on to select
# and the thing that appears on the cursor
# The other items (waterfalls, etc.) derive from it
export(PackedScene) var this_scene
export(String) var tileset_path
export(String) var tileset_name

onready var object_cursor = get_node("/root/Palace/EditorObjectOnCursor")
onready var cursor_sprite = object_cursor.get_node("AnimatedSprite")

func item_clicked(event):
	if event is InputEvent and event.is_action_pressed("click"):
		_on_click()

func _on_Button_pressed():
	_on_click()

func _on_click():
	object_cursor.current_item = this_scene
	object_cursor.current_tileset = tileset_path
	object_cursor.current_tileset_name = tileset_name
	cursor_sprite.frames = $AnimatedSprite.frames
	cursor_sprite.animation = $AnimatedSprite.animation
	cursor_sprite.playing = true
	object_cursor.show()

func _on_Button_mouse_exited():
	object_cursor.can_place = true
	object_cursor.show()

func _on_Button_mouse_entered():
	object_cursor.can_place = false
	object_cursor.hide()
