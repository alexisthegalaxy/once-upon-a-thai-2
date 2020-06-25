extends Node2D

const THAI_START_STORY = "เริ่มเรื่อง"
const THAI_LANGUAGE_CHALLENGES = "คำท้าทางภาษา"
const THAI_QUIT = "เลิก"
const ENG_START_STORY = "Start Story"
const ENG_LANGUAGE_CHALLENGES = "Language Challenges"
const ENG_QUIT = "Quit"

var file = File.new()

func _ready():
	$"CanvasLayer/Start Story".text = THAI_START_STORY
	$"CanvasLayer/Language Challenges".text = THAI_LANGUAGE_CHALLENGES
	$CanvasLayer/Quit.text = THAI_QUIT

func _on_Start_Story_mouse_entered():
	$"CanvasLayer/Start Story".text = ENG_START_STORY
	SoundPlayer.play_thai(THAI_START_STORY)

func _on_Start_Story_button_down():
	Game.call_deferred("_deferred_goto_scene", "res://Maps/Chaiyaphum.tscn", 228, 243)
	
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

func _on_Language_Challenges_button_down():
	var _e = get_tree().change_scene("res://UI/Victory.tscn")