extends CanvasLayer

func stay():
	Game.exit_screen = null
	queue_free()

func leave():
	get_tree().quit()

func _on_Leave_pressed():
	leave()

func _on_Continue_playing_pressed():
	stay()
