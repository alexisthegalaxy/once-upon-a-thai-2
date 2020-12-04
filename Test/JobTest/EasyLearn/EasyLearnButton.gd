extends Node2D

enum {
	DEFAULT,
	PRESSED,
}

var status = DEFAULT
var category  # either "source" or "target"
var word
var index  # 0 if the top one on the screen, etc.
var lo = TranslationServer.get_locale()
signal button_pressed(word_id, category)
signal button_unpressed(word_id, category)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func unpress():
	status = DEFAULT
	modulate = Color(1.0, 1.0, 1.0, 1.0)

func init_easy_learn_button(word_id, _category, _index):
	category = _category
	index = _index
	word = Game.words[str(word_id)]
	if category == "source":
		$Button.text = word[lo]
	else:
		$Button.text = word.th

func _on_Button_pressed():
	if status == DEFAULT:
		modulate = Color(0.5, 1.0, 0.6, 1.0)
		status = PRESSED
		print('status is now pressed', status)
		emit_signal("button_pressed", word.id, category)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
		status = DEFAULT
		print('status is now DEFAULT', status)
		emit_signal("button_unpressed", word.id, category)
