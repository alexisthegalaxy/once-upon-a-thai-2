extends Node2D

func _ready():
	Game.palace = self
	Game.current_scene = self
	SoundPlayer.crossfade_to("res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/Wandering.wav", 0.0)

func ui_cancel():
	$EditorObjectOnCursor.ui_cancel()

func close():
	ChangeMap.call_deferred(
		"_deferred_goto_scene",
		Game.player_last_overworld_map_visited,
		Game.player_position_on_overworld.x,
		Game.player_position_on_overworld.y,
		0
	)
	queue_free()
	Game.palace = null
