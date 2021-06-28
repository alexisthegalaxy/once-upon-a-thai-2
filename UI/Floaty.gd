extends Node2D

export var time_to_live = 4
export var text = "floaty!"
export var distance_to_travel = 8
export var direction = -1
var initial_position_y = position.y
var r = 1
var g = 1
var b = 1
var alpha = 1

func _ready():
	# A Floaty is a piece of text we can show somewhere.
	# It goes slowly up and then disappears (like a crit in WcIII)
	$Label.text = text

func set_direction(_direction):
	if _direction == "up":
		direction = -1
	else:
		direction = 1

func set_color(_r, _g, _b):
	r = _r
	g = _g
	b = _b

func _process(delta):
	position.y = position.y + direction * delta * 10 * distance_to_travel / time_to_live
	alpha -= 0.006 * distance_to_travel / time_to_live
	$Label.modulate = Color(r, g, b, alpha)
	if alpha <= 0:
		queue_free()
	
