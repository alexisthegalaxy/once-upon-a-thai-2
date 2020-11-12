extends CanvasLayer
var sentences = []
var current_sentence_index = 0
var word_id
func _ready():
	pass # Replace with function body.

func init(_word_id):
	word_id = _word_id
	$Thai.text = Game.words[str(word_id)]["th"]
#	print('Game.seen_sentences')
	for sentence_id in Game.seen_sentences + Game.known_sentences:
#		print('    sentence_id ', sentence_id)
		var sentence = Game.sentences[str(sentence_id)]
		if word_id in sentence["word_ids"]:
#			print('word_id ', word_id, ' is seen!')
			sentences.append(sentence)
	if sentences:
		init_interactive_sentence()
#	print(sentences)

func init_interactive_sentence():
	$InteractiveSentence.init(sentences[current_sentence_index], word_id)

func hide():
	$bg.hide()
	$right_arrow.hide()
	$left_arrow.hide()
	$Thai.hide()
	$Button.hide()
	$NoSentence.hide()
	$InteractiveSentence.hide()

func show():
	$bg.show()
	if sentences:
		$InteractiveSentence.show()
		if len(sentences) > 1:
			$right_arrow.show()
			$left_arrow.show()
	$Thai.show()
	$Button.show()
	if not sentences:
		$NoSentence.show()


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
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		current_sentence_index -= 1
		if current_sentence_index < 0:
			current_sentence_index += len(sentences)
		init_interactive_sentence()

func _on_RightArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		current_sentence_index += 1
		if current_sentence_index == len(sentences):
			current_sentence_index = 0
		init_interactive_sentence()
