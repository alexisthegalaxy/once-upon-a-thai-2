extends CanvasLayer

var selected_character = false

func _ready():
	Game.player_name = ""
	update_button_showing()
	$Character_A.init_menu_character(self)
	$Character_B.init_menu_character(self)
	$Character_C.init_menu_character(self)
	$Character_D.init_menu_character(self)
	$Character_E.init_menu_character(self)

func update_button_showing():
	if Game.player_name and selected_character:
		$Button.show()
	else:
		$Button.hide()

func on_selected_character():
	selected_character = true
	update_button_showing()
	$Character_A.set_selected(false)
	$Character_B.set_selected(false)
	$Character_C.set_selected(false)
	$Character_D.set_selected(false)
	$Character_E.set_selected(false)

func _on_Button_pressed():
	if Game.can_read_thai:
		for letter_id in Game.letters:
			Game.known_letters.append(int(letter_id))
	ChangeMap.call_deferred("_deferred_goto_scene", "res://Maps/PlayerHouse.tscn", 24, -143, 0)

#func _on_TextEdit_text_changed():
#	var text = $TextEdit.text
#	print(text)
#	print(len(text))
#	if len(text) > 15:
#		text = text.substr(0, 15)
#		$TextEdit.text = text
#	if "\n" in text:
#		text = text.replace("\n", "")
#		$TextEdit.text = text
#	Game.player_name = $TextEdit.text
#	update_button_showing()

func _on_No_pressed():
	Game.can_read_thai = false
	$Yes.pressed = false
	$No.pressed = true

func _on_Yes_pressed():
	Game.can_read_thai = true
	$Yes.pressed = true
	$No.pressed = false

func _on_LineEdit_text_changed(_new_text):
#	var text = $TextEdit.text
#	print(text)
#	print(len(text))
#	if len(text) > 15:
#		text = text.substr(0, 15)
#		$TextEdit.text = text
#	if "\n" in text:
#		text = text.replace("\n", "")
#		$TextEdit.text = text
	Game.player_name = $LineEdit.text
	update_button_showing()
