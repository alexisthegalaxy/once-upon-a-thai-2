extends Node2D

export(Vector2) var to_position
export(String) var to_map_name
export(String) var name_for_location = ""
export(String) var sound_name = ""
export(int) var level_y_height_change = 0


func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	ChangeMap.call_deferred("_deferred_goto_scene", to_map_name, to_position.x, to_position.y, level_y_height_change)
	if sound_name:
		SoundPlayer.play_sound("res://Sounds/Effects/" + sound_name + ".wav", 0)
	Game.changename(name_for_location)
