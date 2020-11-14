extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func convert_tone_letter_to_name(tone_letter):
	if tone_letter == "L":
		return "Low"
	if tone_letter == "M":
		return "Mid"
	if tone_letter == "H":
		return "High"
	if tone_letter == "R":
		return "Rising"
	if tone_letter == "F":
		return "Falling"
	return "Unknown"

func init_tone_display(tones):
	var SingleToneDisplay = load("res://Lexical/Tones/SingleToneDisplay.tscn")
	var x = position.x - 36
	var y = position.y - 60
	for tone in tones:
		var single_tone_display = SingleToneDisplay.instance()
		single_tone_display.init_single_tone_display(convert_tone_letter_to_name(tone))
		x += 28
		self.add_child(single_tone_display)
		single_tone_display.position = Vector2(x, y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
