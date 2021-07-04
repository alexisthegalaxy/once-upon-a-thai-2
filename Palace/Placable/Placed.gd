extends StaticBody2D
var time = 0 
func _on_ClickInArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		if not Game.palace.mode_is_explore:
			queue_free()

func _physics_process(delta):
	time += delta
	if "PlacedFish" in name:
		$AnimatedSprite.position.y = 2 * cos(time)
