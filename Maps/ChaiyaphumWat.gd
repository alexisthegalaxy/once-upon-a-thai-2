extends Node


func _ready():
	pass
#
#
#func _on_Area2D_body_entered(body):
#	if body == Game.player:
#		Game.space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
#		Game.space_bar_to_interact.get_node("Node2D").get_node("Label").text = "Move with arrow keys or WASD"
#		get_tree().current_scene.add_child(Game.space_bar_to_interact)
#
#func _on_Area2D_body_exited(body):
#	if body == Game.player:
#		Game.space_bar_to_interact.queue_free()
#		Game.space_bar_to_interact = null
