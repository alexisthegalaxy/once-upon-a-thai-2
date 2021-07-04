extends Node2D
# This is both the thing we click on to select and
# the thing that appears on the cursor
# The other items (waterfalls, etc.) inherit this
export(PackedScene) var this_scene
export(String) var tileset_path
export(String) var tileset_name
var object_cursor
var cursor_sprite
var disabled = true

func _ready():
	if not Game.palace:
		Game.palace = get_tree().get_root().get_node("Palace")
	object_cursor = Game.palace.get_node("EditorObjectOnCursor")
	cursor_sprite = object_cursor.get_node("AnimatedSprite")
	disabled = not name.replace('Placable', '') in Game.obtained_collectables
	if disabled:
		modulate = Color(1, 1, 1, 0.3)

func item_clicked(event):
	if disabled:
		return
	if event is InputEvent and event.is_action_pressed("click"):
		_on_click()

func _on_Button_pressed():
	if disabled:
		return
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
	if disabled:
		return
	object_cursor.can_place = true
	object_cursor.show()

func _on_Button_mouse_entered():
	if disabled:
		return
	object_cursor.can_place = false
	object_cursor.hide()
