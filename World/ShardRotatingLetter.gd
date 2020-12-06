extends Node2D

var letter
var ring
var index
var time = 0
const SIZE = 15.0

func _ready():
	pass # Replace with function body.

func init_shard_rotating_letter(_letter, _index, _ring):
	letter = _letter
	index = _index * 5
	ring = _ring
	time = index
	$Label.text = letter
	if ring == 1:
		$Label.modulate = Color(1, 0, 0, 1)
		$Cloud.modulate = Color(0, 0, 0, 0.3)
	elif ring == 2:
		$Label.modulate = Color(0.5, 0, 0, 1)
		$Cloud.modulate = Color(0.2, 0, 0, 0.3)
	else:
		$Label.modulate = Color(0, 0, 0, 1)
		$Cloud.modulate = Color(0.1, 0, 0, 0.3)

func _process(delta):
	if ring == 1:
		position.x = SIZE * cos(-time - index) / 2
		position.y = SIZE * sin(-time - index) + SIZE * cos(-time - index) / 2
		time += delta * 5
	if ring == 2:
		position.x = SIZE * cos(time + index) + SIZE * sin(time + index) / 2
		position.y = SIZE * sin(time + index) / 2
		time += delta * 7
	if ring == 3:
		position.x = SIZE * cos(time + index) / 2 + cos(time * 5 + index) / 2
		position.y = SIZE * sin(time + index) / 2 + sin(time * 5 + index) / 2
		time += delta * 9
	
