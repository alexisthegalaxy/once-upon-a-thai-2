extends Node2D

var thai = ""

func init(_thai):
	thai = _thai


func _on_Area2D_mouse_entered():
	$Sprite.modulate = Color(0, 1, 0, 1)

func _on_Area2D_mouse_exited():
	$Sprite.modulate = Color(1, 1, 1, 1)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
#		print('play ', thai, ' !')
		SoundPlayer.play_thai(thai)
