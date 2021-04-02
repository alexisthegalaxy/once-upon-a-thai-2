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


func _on_chaiyaphum_pressed():
	print('chaiyaphum')

func _on_khonkaen_pressed():
	print('khonkaen')

func _on_chaiyaphum_button_down():
	$chaiyaphum.modulate = Color(1, 0, 0, 1)

func _on_chaiyaphum_button_up():
	$chaiyaphum.modulate = Color(1, 1, 1, 1)

func _on_khonkaen_button_down():
	$khonkaen.modulate = Color(1, 0, 0, 1)

func _on_khonkaen_button_up():
	$khonkaen.modulate = Color(1, 1, 1, 1)
