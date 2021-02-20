extends Node2D

var starts_to_lift = false
var transparency = 1
export var lift_on_letters = ['-ุ']

func _ready():
	pass

func lift():
	starts_to_lift = true

func _process(delta):
	if starts_to_lift:
		$image.position.y -= delta * 100
		transparency -= delta * 4
		$image.modulate = Color(1, 1, 1, transparency)
	if transparency <= 0:
		queue_free()

func _on_Button_pressed():
	lift()
