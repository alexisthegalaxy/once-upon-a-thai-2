extends CanvasLayer

var alpha = 0
var time = 0

func _ready():
	SoundPlayer.play_sound("res://Sounds/Effects/select.wav", -30)

func _process(delta):
	time += delta
	alpha = cos(time * 5) / 2 + 0.5
	$Node2D.modulate = Color(1, 1, 1, alpha)
