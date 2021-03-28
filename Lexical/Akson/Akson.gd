extends CanvasLayer

var letters_ids = []
var has_focus = true

func init_akson(_letters_ids):
	letters_ids = _letters_ids
	$VowelsToFind.init_akson_button_leads_to_letters()
	$ConsonantsToFind.init_akson_button_leads_to_letters()

#func main_ui_process_click(_event) -> bool:
#	var event_is_processed = false
#	if Input.is_action_just_pressed("click"):
#		if hovered_buttons or $QuestsDisplay.is_hovering_over_buttons():
#			event_is_processed = true
#	return event_is_processed

func get_focus():
	has_focus = true
	Game.akson = self
	print('akson get_focus back!')
	$VowelsToFind.init_akson_button_leads_to_letters()
	$ConsonantsToFind.init_akson_button_leads_to_letters()
	self.is_visible = true

func loses_focus():
	
	has_focus = false
	self.is_visible = false

func _on_Vowels_pressed():
	open_subpage("res://Lexical/Akson/SaraPage.tscn")

func _on_Consonants_pressed():
	open_subpage("res://Lexical/Akson/PayanchanaPage.tscn")

func open_subpage(node_name):
	queue_free()
	var subpage = load(node_name).instance()
	subpage.init_akson_subpage()
	Game.akson = subpage
	get_tree().get_root().add_child(subpage)

func exit():
	queue_free()
	ChangeMap.start_test_back_from_akson()

func _on_Vowels_mouse_entered():
	pass # Replace with function body.
