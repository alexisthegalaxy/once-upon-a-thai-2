extends Node2D

const THAI_START_STORY = "เริ่มเรื่อง"
const THAI_LANGUAGE_CHALLENGES = "คำท้าทางภาษา"
const THAI_QUIT = "เลิก"
var ENG_START_STORY = tr("_start_story")
var ENG_LANGUAGE_CHALLENGES = tr("_language_challenges")
var ENG_QUIT = tr("_quit")

onready var audio_stream_player = $AudioStreamPlayer
var file = File.new()

func _ready():
	$CanvasLayer/StartStory.text = THAI_START_STORY
	$CanvasLayer/LanguageChallenges.text = THAI_LANGUAGE_CHALLENGES
	$CanvasLayer/Quit.text = THAI_QUIT
	$CanvasLayer/LanguageSelector.add_item("English")
	$CanvasLayer/LanguageSelector.add_item("Français")
	
	Save.load_game("Alexis")

func retranslate_main_menu_strings():
	ENG_START_STORY = tr("_start_story")
	ENG_LANGUAGE_CHALLENGES = tr("_language_challenges")
	ENG_QUIT = tr("_quit")

func _on_Start_Story_mouse_entered():
	$CanvasLayer/StartStory.text = ENG_START_STORY
	SoundPlayer.play_thai(THAI_START_STORY)

func _on_Start_Story_mouse_exited():
	$CanvasLayer/StartStory.text = THAI_START_STORY

func _on_Language_Challenges_mouse_entered():
	$CanvasLayer/LanguageChallenges.text = ENG_LANGUAGE_CHALLENGES
	SoundPlayer.play_thai(THAI_LANGUAGE_CHALLENGES)

func _on_Language_Challenges_mouse_exited():
	$CanvasLayer/LanguageChallenges.text = THAI_LANGUAGE_CHALLENGES

func _on_Quit_mouse_entered():
	$CanvasLayer/Quit.text = ENG_QUIT
	SoundPlayer.play_thai(THAI_QUIT)

func _on_Quit_mouse_exited():
	$CanvasLayer/Quit.text = THAI_QUIT

func _on_Start_Story_pressed():
	queue_free()
	Game.current_scene = ResourceLoader.load("res://Menu/InitMenu.tscn").instance()
	get_tree().get_root().add_child(Game.current_scene)
#	get_tree().set_current_scene(Game.current_scene)

func _on_Quit_pressed():
	get_tree().quit()


func _on_LanguageSelector_item_selected(index):
	if index == 0:
		TranslationServer.set_locale("en")
	if index == 1:
		TranslationServer.set_locale("fr")
	retranslate_main_menu_strings()
