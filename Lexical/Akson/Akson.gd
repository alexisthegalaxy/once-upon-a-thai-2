extends CanvasLayer

var letters_ids = []
var has_focus = true
var time = 0
var elements_that_progressively_appear
var elements_that_open_up
var show_animation = false
func _ready():
	SoundPlayer.play_sound("res://Sounds/Effects/open_paper_roll.wav", 0)
	elements_that_progressively_appear = [
		$ColorRect,
		$PressFToExit,
		$Vowels,
		$Consonants,
		$VowelsToFind,
		$ConsonantsToFind,
	]
	elements_that_open_up = [
		$TextureRect,
		$Label,
	]

func _process(delta):
	if show_animation:
		if time < 1:
			time += delta
			for element in elements_that_open_up:
				element.rect_scale = Vector2(time, 1)
		if time < 2:
			time += delta
			for element in elements_that_progressively_appear:
				element.modulate = Color(1, 1, 1, time - 1)

func init_akson(_letters_ids, _show_animation):
	show_animation = _show_animation
	letters_ids = _letters_ids
	$VowelsToFind.init_akson_button_leads_to_letters()
	$ConsonantsToFind.init_akson_button_leads_to_letters()
	elements_that_progressively_appear = [
		$ColorRect,
		$PressFToExit,
		$Vowels,
		$Consonants,
		$VowelsToFind,
		$ConsonantsToFind,
	]
	elements_that_open_up = [
		$TextureRect,
		$Label,
	]
	if show_animation:
		for element in elements_that_progressively_appear:
			element.modulate = Color(1, 1, 1, 0)
		for element in elements_that_open_up:
			element.rect_scale = Vector2(0, 1)

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
	if Game.active_test:
		Game.active_test.reactivate_buttons_after_akson()

func _on_Vowels_mouse_entered():
	pass # Replace with function body.
