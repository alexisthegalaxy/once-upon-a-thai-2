extends CanvasLayer

func _on_Leave_pressed():
	get_tree().quit()

func _on_Continue_playing_pressed():
	Game.exit_screen = null
	Game.is_frozen = false
	queue_free()
