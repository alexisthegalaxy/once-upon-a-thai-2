extends Node2D

var width = 0
var height = 0
var is_main_word
var word = null
var can_be_listened

func init_word_in_sentence(word_id, _is_main_word, _can_be_listened):
	can_be_listened = _can_be_listened
	word = Game.words[str(word_id)]
	var text = word["th"]
	is_main_word = _is_main_word
	$Label.text = text
	width = $Label.get_minimum_size()[0]
	height = $Label.get_minimum_size()[1]
	
	# Set collisionShape
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(width/2, height/2))
	$Area2D/CollisionShape2D.set_shape(shape)
	$Area2D/CollisionShape2D.position = Vector2(width/2, height/2)
	
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

func _on_Area2D_mouse_entered():
	$ColorRect.show()
	$Popup/Label.show()
	$Popup.position = Vector2(0, 20)
	$ColorRect.color = Color(1, 0.5, 1, 1)

func _on_Area2D_mouse_exited():
	$Popup/Label.hide()
	if is_main_word:
		$ColorRect.color = Color(1, 0.7, 0.7, 1)
	elif word["id"] in Game.known_words:
		$ColorRect.color = Color(0.7, 1, 0.7, 1)
	else:
		$ColorRect.hide()

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	# We can listen to a word when:
	# - looking at the notebook
	# - looking at a sign
	# But not when:
	# - Looking at the sentences containing a word
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if can_be_listened:
			SoundPlayer.play_thai(word["th"])
		if Game.player.notebook:
			var word_page = load("res://Lexical/WordPage/WordPage.tscn").instance()
			Game.player.word_page = word_page
			Game.current_scene.add_child(word_page)
			word_page.init_word_page(word["id"])
			Game.player.notebook.queue_free()
			Game.player.notebook = null
			

