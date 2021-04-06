extends Node2D

var is_selected = false
var lo = TranslationServer.get_locale()
var word_id
var word
var index = 0
var letters = []
var is_locked = false
signal dock_is_selected
signal erase_letters
signal lock_dock

func _ready():
	$Label.text = ""
	$BackButton.hide()

func update_color():
	if is_locked:
		$Button.modulate = Color(0, 1, 0.5, 1)
	else:
		if is_selected:
			$Button.modulate = Color(0.16, 1, 1, 1)
		else:
			$Button.modulate = Color(1, 1, 1, 1)

func init_purifying_dock(_word_id, _index):
	word_id = _word_id
	word = Game.words[str(word_id)]
	index = _index
	$English.text = Game.words[str(word_id)][lo]

func _on_Button_pressed():
	if is_locked:
		return
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
	if letters == word.letters:
		lock_dock()
	else:
		$BackButton.show()

func lock_dock():
	$BackButton.hide()
	is_locked = true
	SoundPlayer.play_sound("res://Sounds/Effects/correct.wav", 0)
	SoundPlayer.play_thai(word.th)
	update_color()
	emit_signal("lock_dock")

func _on_BackButton_pressed():
	$Label.text = ""
	emit_signal("erase_letters", index, letters)
	letters = []
	$BackButton.hide()

