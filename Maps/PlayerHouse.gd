extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.events["talked_to_nim_at_the_beginning"]:
		$YSort/Nim.position = Vector2(72, -114)


func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
		Game.space_bar_to_interact.get_node("Node2D").get_node("Label").text = "Move with arrow keys or WASD"
		get_tree().current_scene.add_child(Game.space_bar_to_interact)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.space_bar_to_interact.queue_free()
		Game.space_bar_to_interact = null
