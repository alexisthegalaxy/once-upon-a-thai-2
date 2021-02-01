extends Node2D

var primary_value = ""
var shift_value = ""
var keyboard = null
var primary_letter_quantity = 0
var shift_letter_quantity = 0

func init_keyboard_key(_primary_value, _shift_value, _keyboard):
	primary_value = _primary_value
	shift_value = _shift_value
	keyboard = _keyboard
	if $Label:
		$Label.text = primary_value
		if keyboard.restrict_to_collected_letters:
			initial_notification_update()
		else:
			$Notification.hide()

func initial_notification_update():
	# This must only be called upon init, because afterwards we rely on
	# the primary_letter_quantity and shift_letter_quantity set here
	for letter_id in Game.letters:
		var letter = Game.letters[letter_id]
		if letter.th == primary_value:
			primary_letter_quantity = letter.in_bag
		elif letter.th == shift_value:
			shift_letter_quantity = letter.in_bag
	update_upon_shift()

func _on_Button_pressed():
	if primary_value == "shift":
		keyboard.shift = not keyboard.shift
		keyboard.update_all_keys_upon_shift()
		return
	if primary_value == "back":
		keyboard.receive_key_value("back")
		return
	if keyboard.shift:
		if keyboard.restrict_to_collected_letters:
			if shift_letter_quantity > 0:
				shift_letter_quantity -= 1
				update_upon_shift()
				keyboard.receive_key_value(shift_value)
		else:
			keyboard.receive_key_value(shift_value)
	else:
		if keyboard.restrict_to_collected_letters:
			if primary_letter_quantity > 0:
				primary_letter_quantity -= 1
				update_upon_shift()
				keyboard.receive_key_value(primary_value)
		else:
			keyboard.receive_key_value(primary_value)

func update_upon_shift():
	if not $Label:
		return
	if keyboard.shift:
		$Label.text = shift_value
		if keyboard.restrict_to_collected_letters:
			if shift_letter_quantity:
				$Notification.show()
				modulate = Color(1, 1, 1, 1)
				$Notification/Quantity.text = str(shift_letter_quantity)
			else:
				$Notification.hide()
				modulate = Color(1, 1, 1, 0.6)
	else:
		$Label.text = primary_value
		if keyboard.restrict_to_collected_letters:
			if primary_letter_quantity:
				$Notification.show()
				modulate = Color(1, 1, 1, 1)
				$Notification/Quantity.text = str(primary_letter_quantity)
			else:
				$Notification.hide()
				modulate = Color(1, 1, 1, 0.6)

func update_after_char_is_backspaced(character):
	if primary_value in [character, "-" + character]:
		primary_letter_quantity += 1
		update_upon_shift()
	elif shift_value in [character, "-" + character]:
		shift_letter_quantity += 1
		update_upon_shift()
	

#func _on_Button_button_down():
#	if primary_value == "shift":
#		keyboard.shift_down()
#
#func _on_Button_button_up():
#	if primary_value == "shift":
#		keyboard.shift_up()
