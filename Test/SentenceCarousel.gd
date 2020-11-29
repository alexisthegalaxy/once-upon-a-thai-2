extends Node2D
var sentences = []
var current_sentence_index = 0
var word_id
var is_hidden
func _ready():
	pass # Replace with function body.

func init_sentence_carousel(_word_id):
	word_id = _word_id
	$Thai.text = Game.words[str(word_id)]["th"]
#	print('Game.seen_sentences')
	for sentence_id in Game.known_sentences + Game.seen_sentences:
#		print('    sentence_id ', sentence_id)
		var sentence = Game.sentences[str(sentence_id)]
		if word_id in sentence["word_ids"]:
#			print('word_id ', word_id, ' is seen!')
			sentences.append(sentence)
	if sentences:
		$InteractiveSentence.init_interactive_sentence(sentences[current_sentence_index], word_id, false, true, true)
	update_sentence_counter()

func update_sentence_counter():
	$SentenceCounter.text = str(current_sentence_index + 1) + " / " + str(len(sentences))

func hide():
	$bg.hide()
	$right_arrow.hide()
	$left_arrow.hide()
	$Thai.hide()
	$Button.hide()
	$NoSentence.hide()
	$InteractiveSentence.hide()
	$SentenceCounter.hide()
	is_hidden = true

func show():
	$bg.show()
	if sentences:
		$InteractiveSentence.show()
		if len(sentences) > 1:
			$right_arrow.show()
			$left_arrow.show()
			$SentenceCounter.show()
	$Thai.show()
	$Button.show()
	if not sentences:
		$NoSentence.show()
	is_hidden = false


func _on_RightArea_mouse_entered():
	$right_arrow.modulate = Color(1, 0.5, 1, 1)


func _on_RightArea_mouse_exited():
	$right_arrow.modulate = Color(1, 1, 1, 1)


func _on_LeftArea_mouse_entered():
	$left_arrow.modulate = Color(1, 0.5, 1, 1)


func _on_LeftArea_mouse_exited():
	$left_arrow.modulate = Color(1, 1, 1, 1)

func _on_Button_pressed():
	hide()

func _on_LeftArea_input_event(_viewport, event, _shape_idx):
	if is_hidden or not $left_arrow.is_visible():
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		current_sentence_index -= 1
		if current_sentence_index < 0:
			current_sentence_index += len(sentences)
		$InteractiveSentence.init_interactive_sentence(sentences[current_sentence_index], word_id, false, true, true)
		update_sentence_counter()

func _on_RightArea_input_event(_viewport, event, _shape_idx):
	if is_hidden or not $right_arrow.is_visible():
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		current_sentence_index += 1
		if current_sentence_index == len(sentences):
			current_sentence_index = 0
		$InteractiveSentence.init_interactive_sentence(sentences[current_sentence_index], word_id, false, true, true)
		update_sentence_counter()
