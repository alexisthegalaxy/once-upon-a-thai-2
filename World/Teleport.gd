extends Node2D

export(Vector2) var to_position
export(String) var to_map_name
export(String) var sound_name = ""


func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	Game.call_deferred("_deferred_goto_scene", to_map_name, to_position.x, to_position.y)
	if sound_name:
		SoundPlayer.play_sound("res://Sounds/" + sound_name + ".wav")
