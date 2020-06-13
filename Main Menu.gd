extends Node2D

const THAI_START_STORY = "เริ่มเรื่อง"
const THAI_LANGUAGE_CHALLENGES = "คำท้าทางภาษา"
const THAI_QUIT = "เลิก"
const ENG_START_STORY = "Start Story"
const ENG_LANGUAGE_CHALLENGES = "Language Challenges"
const ENG_QUIT = "Quit"

onready var audio_stream_player = $AudioStreamPlayer
var file = File.new()

func _ready():
	$"CanvasLayer/Start Story".text = THAI_START_STORY
	$"CanvasLayer/Language Challenges".text = THAI_LANGUAGE_CHALLENGES
	$CanvasLayer/Quit.text = THAI_QUIT

func _on_Start_Story_mouse_entered():
	$"CanvasLayer/Start Story".text = ENG_START_STORY
	play_sound(THAI_START_STORY)

func _on_Start_Story_button_down():
	var _e = get_tree().change_scene("res://Maps/Chaiyaphum.tscn")
	
func _on_Start_Story_mouse_exited():
	$"CanvasLayer/Start Story".text = THAI_START_STORY

func _on_Language_Challenges_mouse_entered():
	$"CanvasLayer/Language Challenges".text = ENG_LANGUAGE_CHALLENGES
	play_sound(THAI_LANGUAGE_CHALLENGES)

func _on_Language_Challenges_mouse_exited():
	$"CanvasLayer/Language Challenges".text = THAI_LANGUAGE_CHALLENGES

func _on_Quit_mouse_entered():
	$CanvasLayer/Quit.text = ENG_QUIT
	play_sound(THAI_QUIT)

func _on_Quit_mouse_exited():
	$CanvasLayer/Quit.text = THAI_QUIT

func play_sound(thai):
	var audio_file_name = "res://Sounds/Thai/" + thai + ".wav"
	audio_stream_player.stream = load(audio_file_name)
	audio_stream_player.play()
