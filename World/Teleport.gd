extends Node2D

export(Vector2) var to_position
export(String) var to_map_name


func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.call_deferred("_deferred_goto_scene", to_map_name, to_position.x, to_position.y)
