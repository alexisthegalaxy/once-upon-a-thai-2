extends Node2D

var teal_tint = 0
var time = 0
var mouse_in = false
var letter_ids = []

signal leaves_test_to_go_to_MP

func init(_letter_ids, test):
	letter_ids = _letter_ids
	var text = tr("_go_to_the_letter_world_to_learn") + "\n\n"
	for letter_id in letter_ids:
		text += Game.letters[str(letter_id)]["th"] + ", "
	text = text.trim_suffix(", ")
	$Label.text = text
	var _e = self.connect("leaves_test_to_go_to_MP", test, "leaves_test_to_go_to_MP")

func _process(delta):
	if mouse_in:
		$Sprite.modulate = Color(0, 1, 1, 1)
	else:
		time += delta
		teal_tint = 0.5 + 0.5 * cos(time * 15)
		$Sprite.modulate = Color(teal_tint, 1, 1, 1)

func _on_Button_pressed():
	Game.this_letter_world_has_letters = []
	for letter_id in letter_ids:
		Game.letters_we_look_for.append(Game.letters[str(letter_id)])
	Events.enters_lexical_world(null)
	emit_signal("leaves_test_to_go_to_MP")
	Game.active_test.queue_free()
	Game.active_test = null

func _on_Button_mouse_exited():
	mouse_in = false

func _on_Button_mouse_entered():
	mouse_in = true
