extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_payanchana_page():
	pass

func _on_ExitButton_pressed():
	exit()

func exit():
	Game.player.get_node("Camera2D").current = true
	queue_free()
