extends Node2D

func _ready():
	Game.palace = self
	SoundPlayer.crossfade_to("res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/Wandering.wav", 0.0)

func ui_cancel():
	$EditorObjectOnCursor.ui_cancel()

func exit():
	Game.show_exit_screen()
