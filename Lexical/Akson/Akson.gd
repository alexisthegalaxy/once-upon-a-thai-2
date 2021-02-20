extends CanvasLayer

func init_akson():
	pass

#func main_ui_process_click(_event) -> bool:
#	var event_is_processed = false
#	if Input.is_action_just_pressed("click"):
#		if hovered_buttons or $QuestsDisplay.is_hovering_over_buttons():
#			event_is_processed = true
#	return event_is_processed

func _on_Vowels_pressed():
	queue_free()
	var sara_page = load("res://Lexical/Akson/SaraPage.tscn").instance()
	Game.akson = sara_page
	sara_page.init_sara_page()
	Game.current_scene.add_child(sara_page)

func _on_Consonants_pressed():
	queue_free()
	var payanchana_page = load("res://Lexical/Akson/PayanchanaPage.tscn").instance()
	Game.akson = payanchana_page
	payanchana_page.init_payanchana_page()
	Game.current_scene.add_child(payanchana_page)

func exit():
	queue_free()

func _on_Vowels_mouse_entered():
	pass # Replace with function body.
