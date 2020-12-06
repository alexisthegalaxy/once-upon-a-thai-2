extends StaticBody2D

export var sprite_path = "res://World/assets/Mohinkhao1.png"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = load(sprite_path)
