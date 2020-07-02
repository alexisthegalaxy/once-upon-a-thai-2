extends CanvasLayer

var alpha = 0
var time = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	alpha = cos(time * 5) / 2 + 0.5
	$Node2D.modulate = Color(1, 1, 1, alpha)
