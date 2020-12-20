extends CanvasLayer

func _ready():
	Game.player_name = ""
	update_button_showing()

func update_button_showing():
	if Game.player_name:
		$Button.show()
	else:
		$Button.hide()

func _on_Button_pressed():
	Save.load_game(Game.player_name)

func _on_LineEdit_text_changed(_new_text):
	Game.player_name = $LineEdit.text
	update_button_showing()
