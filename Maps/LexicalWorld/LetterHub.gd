extends Node

var fading_in = false
var alpha = 0.0
var has_shown_first_dialog = false

func show_first_dialog():
	$YSort/Yaai.dialog = [
		tr("_you_made_first_step_in_lexical_world"),
		tr("_this_places_will_make_it_easier_for_you_to_learn_the_letters"),
		tr("_your_first_task_will_be_to_find_these_five_letters")
	]
	$YSort/Yaai.post_dialog_event = ["show_looking_for_letters", null]
	$YSort/Yaai.interact()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Events.events["has_been_in_the_letter_world"]:
		Events.events["has_been_in_the_letter_world"] = true
		fading_in = true
		$CanvasLayer/BlackFadeIn.show()
#	Game.letters_we_look_for.append(Game.letters[str(11)])
	
func _process(delta):
	if fading_in:
		alpha += delta / 4
		if alpha >= 0.2 and not has_shown_first_dialog:
			has_shown_first_dialog = true
			call_deferred("show_first_dialog")
		if alpha >= 1:
			alpha = 1
			fading_in = false
		$CanvasLayer/BlackFadeIn.modulate = Color(1, 1, 1, 1 - alpha)
		
	
