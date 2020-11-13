extends Node2D

var teal_tint = 0
var time = 0
var mouse_in = false
var letter_ids = []

func init(_letter_ids):
	letter_ids = _letter_ids
	var text = "Go to your Memory Palace to learn:\n\n"
	for letter_id in letter_ids:
		text += Game.letters[str(letter_id)]["th"] + ", "
	text = text.trim_suffix(", ")
	$Label.text = text

func _process(delta):
	if mouse_in:
		$Sprite.modulate = Color(0, 1, 1, 1)
	else:
		time += delta
		teal_tint = 0.5 + 0.5 * cos(time * 15)
		$Sprite.modulate = Color(teal_tint, 1, 1, 1)

func _on_Area2D_mouse_entered():
	mouse_in = true

func _on_Area2D_mouse_exited():
	mouse_in = false

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		for letter_id in letter_ids:
			Game.letters_we_look_for.append(Game.letters[str(letter_id)])
		Events.enters_lexical_world(null)
		Game.active_test.queue_free()  # TODO!
		Game.active_test = null
