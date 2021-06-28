extends StaticBody2D

func _on_ClickInArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if not Game.palace.mode_is_explore:
			queue_free()
