extends Node

var fading_in = false
var alpha = 0.0

func show_first_dialog():
	$YSort/Yaai.dialog = [
		"[Name], you made your first step in the Letter World, this shall be your Memory Palace.",
		"",
		"",
	]
	$YSort/Yaai.post_dialog_event = ["show_looking_for_letters", null]
	$YSort/Yaai.interact()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Events.events["has_been_in_the_letter_world"]:
		Events.events["has_been_in_the_letter_world"] = true
		fading_in = true
		$CanvasLayer/BlackFadeIn.show()
#		call_deferred("show_first_dialog")
#	Game.letters_we_look_for.append(Game.letters[str(11)])
	
func _process(delta):
	if fading_in:
		alpha += delta / 4
		if alpha >= 1:
			alpha = 1
			fading_in = false
#			print("call_deferred(show_first_dialog)")
			call_deferred("show_first_dialog")
#			print("after call_deferred(show_first_dialog)")
		$CanvasLayer/BlackFadeIn.modulate = Color(1, 1, 1, 1 - alpha)
		
	
