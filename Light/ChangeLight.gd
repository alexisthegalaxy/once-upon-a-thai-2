extends Area2D

export(Color) var color

func _on_Teleport_body_entered(_body):
	if _body.get_name() == "Player":
		Game.change_color = true
		Game.goal_color = color
		Game.last_goal_color = color
