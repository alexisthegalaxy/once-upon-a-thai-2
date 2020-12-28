extends CanvasLayer

func _ready():
	Game.player_name = ""
	update_button_showing()

func update_button_showing():
	if Game.player_name:
		$StartButton.show()
	else:
		$StartButton.hide()

func _on_LineEdit_text_changed(_new_text):
	Game.player_name = $LineEdit.text
	update_button_showing()

func _on_BackButton_pressed():
	queue_free()
	Game.current_scene = ResourceLoader.load("res://Menu/MainMenu.tscn").instance()
	get_tree().get_root().add_child(Game.current_scene)

func _on_StartButton_pressed():
	Save.load_game(Game.player_name)
