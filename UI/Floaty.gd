extends Node2D

export var time_to_live = 4
export var text = "floaty!"
export var distance_to_travel_up = 8
var initial_position_y = position.y
var alpha = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= delta * 10 * distance_to_travel_up / time_to_live
	alpha -= 0.006 * distance_to_travel_up / time_to_live
	$Label.modulate = Color(1, 1, 1, alpha)
	if alpha <= 0:
		queue_free()
	
