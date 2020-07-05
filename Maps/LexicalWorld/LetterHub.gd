extends Node

func show_first_dialog():
	if not Events.events["has_been_in_the_letter_world"]:
		$YSort/Yaai.dialog = [
			"Yaai: [Name], you made your first step in the Letter World, this shall be your Memory Palace.",
			"Yaai: This place will make it easier for you to learn the letters.",
			"Yaai: Your first task will be to find the following letters: น, ท, ย, ค, ไ-.",
		]
		$YSort/Yaai.post_dialog_event = ["show_looking_for_letters", null]
		$YSort/Yaai.interact()

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("show_first_dialog")
	
