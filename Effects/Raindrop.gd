extends Node2D

var speed = 250
var x = 0
var initial_x

func _ready():
	initial_x = position.x
	speed += randi() % 20

func init_rain_drop(_x):
	x = _x
	rotation = -x / 3

func _process(delta):
	position.y += delta * speed
	position.x += x
	if position.y > 180 or randi() % 20 == 0:
		position.x = initial_x
		position.y = randi() % 180 - 20
