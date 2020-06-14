extends CanvasLayer

var full_width
var full_height

func _ready():
	full_width = $Red.rect_size[0]
	full_height = $Red.rect_size[1]

func set_life(current_life, full_life):
	var percentage = current_life / full_life
	$Red.rect_size = Vector2(full_width * percentage, full_height)
