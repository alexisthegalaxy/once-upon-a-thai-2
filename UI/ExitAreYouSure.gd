extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func stay():
	Game.exit_screen = null
	queue_free()

func leave():
	get_tree().quit()

func _on_Leave_pressed():
	leave()

func _on_Continue_playing_pressed():
	stay()
