extends Node2D

export(Vector2) var to = Vector2(120, -68)
const DISTANCE_FROM_PLAYER = 40
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var angle = Vector2(1, 0).angle_to(Game.player.position - to)
	position = Game.player.position - DISTANCE_FROM_PLAYER * Vector2(cos(angle), sin(angle))
	var distance_to_goal = to.distance_to(position)
	var alpha = max((distance_to_goal - DISTANCE_FROM_PLAYER)/10, 0)
	self.modulate = Color(1, 1, 1, max(min(alpha, 1), 0))
	rotation = angle + PI/2
