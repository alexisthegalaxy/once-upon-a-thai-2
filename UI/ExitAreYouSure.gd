extends CanvasLayer

func _ready():
	if Game.palace:
		if Game.following_words:
			$ColorRect/Leave.disabled = true
			$ColorRect/Leave.text = tr("_you_cant_leave_when_you_carry_a_word")
		else:
			$ColorRect/Leave.text = tr("_go_back_to_the_material_world")

func _on_Leave_pressed():
	if Game.palace:
		Game.palace.close()
		return
	get_tree().quit()

func _on_Continue_playing_pressed():
	Game.exit_screen = null
	Game.is_frozen = false
	queue_free()
