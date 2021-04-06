extends Node

var music_from_map = {
	"res://Maps/Chaiyaphum.tscn": "res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/16 Wandering.wav",
	"res://Maps/PlayerHouse.tscn": "res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/14 Grass.wav",
}

var is_crossfading = false
var main_music_playing = null
var secondary_music_playing = null
var main_music = "A"
onready var available_sound_stream = $SoundEffectAudioStreamPlayer1

var min_db = -50
var max_db = -20
var music_a_db = -100
var music_b_db = -100

func _process(delta):
	if is_crossfading:
		if main_music == "A":
			if music_a_db < max_db:
				music_a_db += delta * 50
			if music_b_db > min_db:
				music_b_db -= delta * 5
			if music_b_db <= min_db and music_a_db >= max_db:
				is_crossfading = false
				$Music_B.stop()
		else:
			if music_b_db < max_db:
				music_b_db += delta * 50
			if music_a_db > min_db:
				music_a_db -= delta * 5
			if music_a_db <= min_db and music_b_db >= max_db:
				is_crossfading = false
				$Music_A.stop()
		
		$Music_A.set_volume_db(music_a_db)
		$Music_B.set_volume_db(music_b_db)

func crossfade_to(music_file, from_position):
	is_crossfading = true
	if main_music == "A":
		main_music = "B"
		$Music_B.stream = load(music_file)
		$Music_B.set_volume_db(min_db)
		$Music_B.play(from_position)
	else:
		main_music = "A"
		$Music_A.stream = load(music_file)
		$Music_A.set_volume_db(min_db)
		$Music_A.play(from_position)

func start_music_upon_entering_map(map_name):
	if map_name in music_from_map:
		crossfade_to(music_from_map[map_name], 0.0)

func has_audio(thai):
	var file_path = get_audio_file_path_from_thai(thai) + ".import"
	return Directory.new().file_exists(file_path)

func get_audio_file_path_from_thai(thai):
	return "res://Sounds/Thai/" + thai + ".wav"

func play_thai(thai):
	var audio_file_name = get_audio_file_path_from_thai(thai)
	$ThaiAudioStreamPlayer.stream = load(audio_file_name)
	$ThaiAudioStreamPlayer.play()

func play_sound(audio_file_name, db_level):
	available_sound_stream.stream = load(audio_file_name)
	available_sound_stream.set_volume_db(db_level)
	available_sound_stream.play()
	if available_sound_stream.name == "SoundEffectAudioStreamPlayer1":
		available_sound_stream = $SoundEffectAudioStreamPlayer2
	elif available_sound_stream.name == "SoundEffectAudioStreamPlayer2":
		available_sound_stream = $SoundEffectAudioStreamPlayer1
