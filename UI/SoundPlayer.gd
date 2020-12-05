extends Node

var music_from_map = {
	"res://Maps/Chaiyaphum.tscn": "res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/16 Wandering.wav",
	"res://Maps/PlayerHouse.tscn": "res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/14 Grass.wav",
	"res://Maps/LexicalWorld/LetterHub.tscn": "res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/21 Slowly.wav",
}

var is_crossfading = false
var main_music_playing = null
var secondary_music_playing = null
var main_music = "A"

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

func crossfade_to(music_file):
	is_crossfading = true
	if main_music == "A":
		main_music = "B"
		$Music_B.stream = load(music_file)
		$Music_B.set_volume_db(min_db)
		$Music_B.play()
	else:
		main_music = "A"
		$Music_A.stream = load(music_file)
		$Music_A.set_volume_db(min_db)
		$Music_A.play()

func start_music_upon_entering_map(map):
	if map in music_from_map:
#		if not music_playing:
#			music_playing = music_from_map[map]
#			$Music.stream = load(music_playing)
#			$Music.play()
#			$Music.set_volume_db(-10.0)
#		elif not music_playing == music_from_map[map]:
		crossfade_to(music_from_map[map])
#		music_playing = music_from_map[map]

func play_thai(thai):
	var audio_file_name = "res://Sounds/Thai/" + thai + ".wav"
	$ThaiAudioStreamPlayer.stream = load(audio_file_name)
	$ThaiAudioStreamPlayer.play()

func play_sound(audio_file_name, db_level):
	$GeneralAudioStreamPlayer.stream = load(audio_file_name)
	$GeneralAudioStreamPlayer.set_volume_db(db_level)
	$GeneralAudioStreamPlayer.play()
