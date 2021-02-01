extends Node2D

var width = 0
var height = 0
var is_main_word
var word = null

func init_word_in_sentence(word_id, _is_main_word):
	word = Game.words[str(word_id)]
	var text = word["th"]
	is_main_word = _is_main_word
	$Label.text = text
	width = $Label.get_minimum_size()[0]
	height = $Label.get_minimum_size()[1]
	$Button.set_size(Vector2(width, height))
	
	# Set main ColorRect
	$ColorRect.set_size(Vector2(width, height))
	if is_main_word:
		$ColorRect.color = Color(1, 0.7, 0.7, 1)
	elif word["id"] in Game.known_words:
		$ColorRect.color = Color(0.7, 1, 0.7, 1)
	else:
		$ColorRect.hide()
	
	# Set popup
	if word_id in Game.known_words:
		$Popup/Label.text = word[TranslationServer.get_locale()]
	else:
		$Popup/Label.text = tr("_unknown_meaning")
	$Popup/Label.hide()

func _on_Button_mouse_entered():
	$ColorRect.show()
	$Popup/Label.show()
	$Popup.position = Vector2(0, 20)
	$ColorRect.color = Color(1, 0.5, 1, 1)
	SoundPlayer.play_thai(word["th"])

func _on_Button_mouse_exited():
	$Popup/Label.hide()
	if is_main_word:
		$ColorRect.color = Color(1, 0.7, 0.7, 1)
	elif word["id"] in Game.known_words:
		$ColorRect.color = Color(0.7, 1, 0.7, 1)
	else:
		$ColorRect.hide()

func _on_Button_pressed():
	SoundPlayer.play_thai(word["th"])
	if Game.notebook:
		var word_page = load("res://Lexical/WordPage/WordPage.tscn").instance()
		Game.word_page = word_page
		Game.current_scene.add_child(word_page)
		word_page.init_word_page(word["id"])
		Game.notebook.queue_free()
		Game.notebook = null
