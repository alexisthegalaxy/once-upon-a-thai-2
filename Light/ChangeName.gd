extends Area2D

export(String) var location_name

func _on_Teleport_body_entered(_body):
	if _body.get_name() == "Player":
		Game.changename(location_name)
