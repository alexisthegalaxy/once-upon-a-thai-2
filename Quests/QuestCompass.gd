extends Node2D

var goal_location
var time = 0

func _process(delta):
	if not goal_location:
		return
	time += delta
	var angle = Vector2(1, 0).angle_to(Game.player.position - goal_location)
	$Arrow.rotation = angle - PI/4 + 0.1 * cos(time)

func init_quest_compass(_goal_location):
	if not _goal_location:
		hide()
	goal_location = _goal_location
