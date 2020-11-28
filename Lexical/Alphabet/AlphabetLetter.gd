extends Node2D

var letter

func init_alphabet_letter(letter_id):
	letter = Game.letters[str(letter_id)]
	$Button.text = letter["th"]
	if Game.knows_letter(letter):
		$Button.modulate = Color(0, 1, 1, 1)
	else:
		$Button.modulate = Color(1, 1, 1, 1)

func _on_Button_pressed():
#	if not Game.knows_letter(letter):  # should not be commented
#		return
	var letter_page = load("res://Lexical/Letter/LetterPage.tscn").instance()
	Game.player.letter_page = letter_page
	Game.current_scene.add_child(letter_page)
	letter_page.init_letter_page(letter["id"])
	Game.player.alphabet.queue_free()
	Game.player.alphabet = null


func _on_Button_mouse_entered():
	SoundPlayer.play_thai(letter.audio)
