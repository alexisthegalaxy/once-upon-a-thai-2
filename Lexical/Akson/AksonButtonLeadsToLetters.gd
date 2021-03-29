extends Node2D

export var types = ['VOWEL']
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_akson_button_leads_to_letters():
	var text = ""
	for letter in Game.letters_we_look_for:
		if (not letter.id in Game.known_letters) and (letter["class"] in types):
			text += letter.th + " "
	$Label.text = text
	
