extends Node

func play_thai(thai):
	var audio_file_name = "res://Sounds/Thai/" + thai + ".wav"
	$AudioStreamPlayer.stream = load(audio_file_name)
	$AudioStreamPlayer.play()
