extends Node2D

var primary_value = ""
var shift_value = ""
var keyboard = null

func init_keyboard_key(_primary_value, _shift_value, _keyboard):
	primary_value = _primary_value
	shift_value = _shift_value
	if $Label:
		$Label.text = primary_value
	keyboard = _keyboard

func _on_Button_pressed():
	if primary_value == "shift":
		keyboard.shift = not keyboard.shift
		keyboard.update_all_keys_upon_shift()
	if keyboard.shift:
		keyboard.receive_key_value(shift_value)
	else:
		keyboard.receive_key_value(primary_value)

func update_upon_shift():
	if not $Label:
		return
	if keyboard.shift:
		$Label.text = shift_value
	else:
		$Label.text = primary_value

#func _on_Button_button_down():
#	if primary_value == "shift":
#		keyboard.shift_down()
#
#func _on_Button_button_up():
#	if primary_value == "shift":
#		keyboard.shift_up()
