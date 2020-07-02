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
	SoundPlayer.play_thai(THAI_START_STORY)

func _on_Start_Story_mouse_exited():
	$"CanvasLayer/Start Story".text = THAI_START_STORY

func _on_Language_Challenges_mouse_entered():
	$"CanvasLayer/Language Challenges".text = ENG_LANGUAGE_CHALLENGES
	SoundPlayer.play_thai(THAI_LANGUAGE_CHALLENGES)

func _on_Language_Challenges_mouse_exited():
	$"CanvasLayer/Language Challenges".text = THAI_LANGUAGE_CHALLENGES

func _on_Quit_mouse_entered():
	$CanvasLayer/Quit.text = ENG_QUIT
	SoundPlayer.play_thai(THAI_QUIT)

func _on_Quit_mouse_exited():
	$CanvasLayer/Quit.text = THAI_QUIT

func _on_Start_Story_pressed():
	queue_free()
	Game.current_scene = ResourceLoader.load("res://Menu/InitMenu.tscn").instance()
	get_tree().get_root().add_child(Game.current_scene)
	get_tree().set_current_scene(Game.current_scene)

func _on_Quit_pressed():
	get_tree().quit()
