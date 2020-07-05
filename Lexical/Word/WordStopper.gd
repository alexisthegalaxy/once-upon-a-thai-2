extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var stops_ids = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	if (not body == Game.player) and ("@Word@" in body.name):
		if body.id in stops_ids:
			body.starts_disappearing()
