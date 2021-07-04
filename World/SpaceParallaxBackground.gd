extends ParallaxBackground


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for parallax_layer in [$ParallaxLayer, $ParallaxLayer1, $ParallaxLayer2, $ParallaxLayer3]:
		parallax_layer.position = Vector2(0, 0)
		parallax_layer.scale = Vector2(1, 1)
