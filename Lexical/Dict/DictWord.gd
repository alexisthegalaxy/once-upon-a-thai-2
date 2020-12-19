extends Node2D

var word

func init_dict_word(word_id):
	word = Game.words[str(word_id)]
	$Button.text = word["th"]
	if Game.knows_word(word):
		$Button.modulate = Color(0, 1, 1, 1)
	else:
#		$Button.disabled = true
		$Button.modulate = Color(1, 1, 1, 1)

func _on_Button_pressed():
	if Game.knows_word(word):
		SoundPlayer.play_thai(word["th"])
		var word_page = load("res://Lexical/WordPage/WordPage.tscn").instance()
		Game.player.word_page = word_page
		Game.current_scene.add_child(word_page)
		word_page.init_word_page(word["id"])
		Game.ict.queue_free()
		Game.dict = null
