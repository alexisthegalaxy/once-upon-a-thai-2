extends Node2D

func _ready():
	Game.palace = self

func ui_cancel():
	$EditorObjectOnCursor.ui_cancel()

func exit():
	Game.show_exit_screen()
