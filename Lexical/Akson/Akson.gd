extends CanvasLayer

var letters_ids = []

func init_akson(_letters_ids):
	letters_ids = _letters_ids

#func main_ui_process_click(_event) -> bool:
#	var event_is_processed = false
#	if Input.is_action_just_pressed("click"):
#		if hovered_buttons or $QuestsDisplay.is_hovering_over_buttons():
#			event_is_processed = true
#	return event_is_processed

func get_letters_by_letter_class(letter_classes):
	var vowels = []
	for letter_id in letters_ids:
		var letter = Game.letters[str(letter_id)]
		if letter["class"] in letter_classes:
			vowels.append(letter)
	return vowels

func _on_Vowels_pressed():
	queue_free()
	var sara_page = load("res://Lexical/Akson/SaraPage.tscn").instance()
	Game.letters_we_look_for = get_letters_by_letter_class(["VOWELS"])
	sara_page.init_sara_page()
	Game.akson = sara_page
	get_tree().get_root().add_child(sara_page)

func _on_Consonants_pressed():
	queue_free()
	var payanchana_page = load("res://Lexical/Akson/PayanchanaPage.tscn").instance()
	Game.letters_we_look_for = get_letters_by_letter_class(["LOW", "MID", "HIGH"])
	payanchana_page.init_payanchana_page()
	Game.akson = payanchana_page
	get_tree().get_root().add_child(payanchana_page)

func exit():
	queue_free()
	ChangeMap.start_test_back_from_akson()

func _on_Vowels_mouse_entered():
	pass # Replace with function body.
