extends Node2D

var letters_we_look_for = []  # list of letters
var letters_we_look_for_that_we_know = []  # list of letters
var letters_we_look_for_that_we_dont_know = []  # list of letters

const TRANSPARENT_BLACK = "[color=#22000000]"
const OPAQUE_BLACK = "[color=#FF000000]"

func init_letters_we_look_for(_letters_we_look_for):
	letters_we_look_for = _letters_we_look_for
	if len(Game.letters_we_look_for):
		update_label_text()
	else:
		queue_free()

func update_label_text():
	var all_letters_are_known = true
	for letter in letters_we_look_for:
		if letter["id"] in Game.known_letters:
			letters_we_look_for_that_we_know.append(letter["id"])
		else:
			letters_we_look_for_that_we_dont_know.append(letter["id"])
	var text = tr("_looking_for_letters")
	for letter in letters_we_look_for:
		if letter["id"] in letters_we_look_for_that_we_know:
			text += TRANSPARENT_BLACK + letter["th"] + "[/color]" + ", "
		else:
			all_letters_are_known = false
			text += OPAQUE_BLACK + letter["th"] +"[/color]" +  ", "
	if all_letters_are_known:
		$Label.bbcode_text = tr("_found_required_letters")
	else:
		text = text.trim_suffix(", ")
		$Label.bbcode_text = text
