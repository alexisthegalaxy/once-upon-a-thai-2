extends CanvasLayer


var letters_we_look_for = []  # list of letters
var letters_we_look_for_that_we_know = []  # list of letters
var letters_we_look_for_that_we_dont_know = []  # list of letters

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(_letters_we_look_for):
	letters_we_look_for = _letters_we_look_for
	if len(Game.letters_we_look_for):
		update_label_text()
	else:
		queue_free()
		
func update_label_text():
	for letter in letters_we_look_for:
		if letter["id"] in Game.known_letters:
			letters_we_look_for_that_we_know.append(letter["id"])
		else:
			letters_we_look_for_that_we_dont_know.append(letter["id"])
	var text = "Looking for letters: "
	for letter in letters_we_look_for:
		if letter["id"] in letters_we_look_for_that_we_know:
			text += "[color=#22000000]" + letter["th"] + "[/color]" + ", "
		else:
			text += "[color=#FF000000]" + letter["th"] +"[/color]" +  ", "
	text = text.trim_suffix(", ")
	print('text', text)
	$Label.bbcode_text = text
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
