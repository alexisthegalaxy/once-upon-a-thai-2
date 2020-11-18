extends CanvasLayer

var word

# Called when the node enters the scene tree for the first time.
func _ready():
	$SentenceCarousel.hide()
	pass # Replace with function body.

func init_word_page(_word):
	word = Game.words[str(_word)]
	$Thai.text = word["th"]
	$English.text = word["en"]
	$TestSoundPlayer.init_sound_player(word["th"])
	$SentenceCarousel.init_sentence_carousel(word["id"])
	$ToneDisplay.init_tone_display(word["tones"])

func _on_Button_pressed():
	$SentenceCarousel.show()


func _on_OkButton_pressed():
	var dict = load("res://Lexical/Dict/Dict.tscn").instance()
	Game.player.dict = dict
	dict.init()
	Game.current_scene.add_child(dict)
	Game.player.word_page = null
	self.queue_free()
