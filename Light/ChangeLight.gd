extends Area2D

export(Color) var color

func _on_Teleport_body_entered(_body):
	if _body.get_name() == "Player":
		Game._on_changelight_entered(color)
