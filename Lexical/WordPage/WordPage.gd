extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var word

# Called when the node enters the scene tree for the first time.
func _ready():
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
