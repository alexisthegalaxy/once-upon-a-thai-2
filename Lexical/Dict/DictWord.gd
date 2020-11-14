extends Node2D

var thai = "นาม"
var is_known = false

func set_thai(_thai):
	thai = _thai
	$Button.text = thai

func set_known(_is_known):
	is_known = _is_known
	if is_known:
		$Button.modulate = Color(0, 1, 1, 1)
	else:
		$Button.modulate = Color(1, 1, 1, 1)

func _on_StaticBody2D_input_event(viewport, event, shape_idx):
	print("click")
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		SoundPlayer.play_sound(thai)

func _on_Button_pressed():
	print("click ", thai)
	SoundPlayer.play_thai(thai)
