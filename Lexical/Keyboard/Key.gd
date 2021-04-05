extends Node2D

var primary_value = ""
var shift_value = ""
var keyboard = null
var primary_letter_quantity = 0
var shift_letter_quantity = 0
var normal_color = Color(1, 1, 1, 1)
var disabled_color = Color(1, 1, 1, 0.6)
var invisible_color = Color(1, 1, 1, 0.3)
var primary_letter_is_known = false
var shift_letter_is_known = false
var restrict_to_known_letters = true

func is_this_letter_known():
	if Game.can_read_thai:
		primary_letter_is_known = true
		shift_letter_is_known = true
		return
	for letter_id in Game.known_letters:
		var known_letter_thai = Game.letters[str(letter_id)].th
		if known_letter_thai in [primary_value, "-" + primary_value]:
			primary_letter_is_known = true
		if known_letter_thai in [shift_value, "-" + shift_value]:
			shift_letter_is_known = true
	if not primary_letter_is_known:
		modulate = invisible_color

func init_keyboard_key(_primary_value, _shift_value, _keyboard):
	primary_value = _primary_value
	shift_value = _shift_value
	keyboard = _keyboard
	is_this_letter_known()
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
		if restrict_to_known_letters:
			if not shift_letter_is_known:
				modulate = invisible_color
		if keyboard.restrict_to_collected_letters:
			if shift_letter_quantity:
				$Notification.show()
				modulate = normal_color
				$Notification/Quantity.text = str(shift_letter_quantity)
			else:
				$Notification.hide()
				modulate = disabled_color
	else:
		if restrict_to_known_letters:
			if not primary_letter_is_known:
				modulate = invisible_color
		$Label.text = primary_value
		if keyboard.restrict_to_collected_letters:
			if primary_letter_quantity:
				$Notification.show()
				modulate = normal_color
				$Notification/Quantity.text = str(primary_letter_quantity)
			else:
				$Notification.hide()
				modulate = disabled_color

func update_after_char_is_backspaced(character):
	if primary_value in [character, "-" + character]:
		primary_letter_quantity += 1
		update_upon_shift()
	elif shift_value in [character, "-" + character]:
		shift_letter_quantity += 1
		update_upon_shift()
