extends StaticBody2D

export var collectable_name = "name";

func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	if not collectable_name in Game.obtained_collectables:
		print(collectable_name + " has been collected")
		Game.obtained_collectables.append(collectable_name)
		var floaty = load("res://UI/Floaty.tscn").instance()
		floaty.text = collectable_name + " has been collected"
		floaty.position = to_local(position)
		self.add_child(floaty)
