extends StaticBody2D

export var collectable_name = "name";

func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	print(name + " has been collected")
