extends Node2D
#
#export(Vector2) var to = Vector2(120, -68)
#const DISTANCE_FROM_PLAYER = 40
#var time = 0
#var variance = 0
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
#func init(to_):
#	to = to_

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	time += delta
#	var angle = Vector2(1, 0).angle_to(Game.player.position - to)
#
#	var distance_to_goal = to.distance_to(Game.player.position)
#	if distance_to_goal > 100:
#		variance = cos(time) * min((distance_to_goal - 100) / 10, 10)
#	else:
#		variance = 0
#	position = -(variance + DISTANCE_FROM_PLAYER) * Vector2(cos(angle), sin(angle))
#	var alpha = max(pow((distance_to_goal - DISTANCE_FROM_PLAYER)/100, 4), 0)
#	self.modulate = Color(1, 1, 1, max(min(alpha, 1), 0))
#	rotation = angle + PI/2
