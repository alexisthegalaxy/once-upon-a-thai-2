extends Node2D

var is_known

var letter

func init(_letter):
	letter = _letter
	$thai.text = letter["th"]
	$Sprite.modulate = Color(0.5, 0.5, 0.5, 0.5)

func set_known(_is_known):
	is_known = _is_known
	if is_known:
		$Sprite.modulate = Color(0, 1, 1, 0.5)

func _on_Area2D_mouse_entered():
	$Sprite.modulate = Color(1, 0, 0, 0.5)

func _on_Area2D_mouse_exited():
	if is_known:
		$Sprite.modulate = Color(0, 1, 1, 0.5)
	else:
		$Sprite.modulate = Color(0.5, 0.5, 0.5, 0.5)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print('play ', letter["audio"])
		SoundPlayer.play_thai(letter["audio"])
