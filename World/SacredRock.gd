extends StaticBody2D

export var is_pulsating = false
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if not is_pulsating:
		$PulsatingSprite.hide()
		$Light.hide()

func _process(delta):
	if is_pulsating:
		time += delta
		var ondulation = cos(time)
		var alpha = 0.7 - 0.3 * ondulation
#		$Light.modulate = Color(1, 1, 1, alpha)
		$Light.energy = alpha
		$PulsatingSprite.modulate = Color(1, 1, 1, alpha)
