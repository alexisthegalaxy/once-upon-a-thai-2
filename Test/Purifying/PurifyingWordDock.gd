extends Node2D

var is_selected = false
var lo = TranslationServer.get_locale()
var word_id
var index = 0
var letters = []
signal dock_is_selected
signal erase_letters

func _ready():
	$Label.text = ""
	$BackButton.hide()

func update_color():
	if is_selected:
		$Button.modulate = Color(0.16, 1, 1, 1)
	else:
		$Button.modulate = Color(1, 1, 1, 1)

func init_purifying_dock(_word_id, _index):
	word_id = _word_id
	index = _index
	$English.text = Game.words[str(word_id)][lo]

func _on_Button_pressed():
	if not is_selected:
		is_selected = true
		update_color()
		emit_signal("dock_is_selected", index)

func unselect_dock():
	is_selected = false
	update_color()

func add_letter(letter_id):
	letters.append(letter_id)
	var letter = Game.letters[str(letter_id)]
	$Label.text += letter.th.replace("-", "")
	$BackButton.show()

func _on_BackButton_pressed():
	$Label.text = ""
	emit_signal("erase_letters", index, letters)
	letters = []
	$BackButton.hide()

