extends Node2D

var teal_tint = 0
var time = 0
var mouse_in = false
var letter_ids = []

func make_label_text():
	var text = tr("_open_your_akson_and_learn") + "\n\n"
	for letter_id in letter_ids:
		text += Game.letters[str(letter_id)]["th"] + ", "
	text = text.trim_suffix(", ")
	return text

func update_known_letters():
	var new_letter_ids = []
	for letter_id in letter_ids:
		if not letter_id in Game.known_letters:
			new_letter_ids.append(letter_id)
	if not new_letter_ids:
		queue_free()
	letter_ids = new_letter_ids
	$Label.text = make_label_text()

func init_learn_letter_button(_letter_ids, test):
	letter_ids = _letter_ids
	$Label.text = make_label_text()
	var _e = self.connect("leaves_test_to_go_to_MP", test, "leaves_test_to_go_to_MP")

func _process(delta):
	if mouse_in:
		$Sprite.modulate = Color(0, 1, 1, 1)
	else:
		time += delta
		teal_tint = 0.5 + 0.5 * cos(time * 15)
		$Sprite.modulate = Color(teal_tint, 1, 1, 1)

func open_akson():
	var akson = load("res://Lexical/Akson/Akson.tscn").instance()
	Game.akson = akson
	akson.init_akson(letter_ids)
	get_tree().get_root().add_child(akson)

func _on_Button_pressed():
	Game.this_letter_world_has_letters = []
	for letter_id in letter_ids:
		Game.letters_we_look_for.append(Game.letters[str(letter_id)])
#	Events.enters_lexical_world(null)
	open_akson()
	# Issue here: we want Akson to appear over the test, but it appears below
#	Game.active_test.hide()
#	emit_signal("leaves_test_to_go_to_MP")  # Saves data in the Game.should_start_test_when_back_from_MP
#	Game.active_test.queue_free()  # Do we need that?
#	Game.active_letter_test = null

func _on_Button_mouse_exited():
	mouse_in = false

func _on_Button_mouse_entered():
	mouse_in = true
