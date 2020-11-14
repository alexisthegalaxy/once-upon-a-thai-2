extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_single_tone_display(tone):
	# tone is in ["Falling", "High", "Low", "Mid", "Rising"]
	var sprite_path = "res://Lexical/Tones/" + tone + ".png"
	$ToneGraph.texture = load(sprite_path)
	$Label.text = tone
