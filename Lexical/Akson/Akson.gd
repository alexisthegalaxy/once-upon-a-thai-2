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
	# Problem: we can't have a non canvas over a canvas.
	# The test is canvas
	# SaraPage can't be canvas - otherwise the camera doesn't move around.
		# We could move around all the items in it instead?
		# That way, there's no problems with changing the main camera
	
	queue_free()
	var sara_page = load("res://Lexical/Akson/SaraPage.tscn").instance()
	Game.akson = sara_page
#	Game.main_ui.add_child(sara_page)
#	Game.main_ui.add_child(sara_page)
#	Game.akson.add_child(sara_page)
	get_tree().get_root().add_child(sara_page)
#	Game.move_child(sara_page, 0)
#	Game.print_entire_tree()
#	Game.current_scene.add_child(sara_page)

func _on_Consonants_pressed():
	queue_free()
	var payanchana_page = load("res://Lexical/Akson/PayanchanaPage.tscn").instance()
	Game.akson = payanchana_page
	payanchana_page.init_payanchana_page()
	Game.current_scene.add_child(payanchana_page)

func exit():
	queue_free()
	ChangeMap.start_test_back_from_akson()

func _on_Vowels_mouse_entered():
	pass # Replace with function body.
