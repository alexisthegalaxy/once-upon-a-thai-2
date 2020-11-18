extends CanvasLayer

var has_learnt_the_sentence = false
var has_seen_the_sentence = false
var sentence = null

func sentence_discovery_init(sentence_id, is_translated):
	sentence = Game.sentences[str(sentence_id)]
	if is_translated:
		$LabelSmall.hide()
		$Label.text = "You've learned a sentence!"
		if sentence_id in Game.known_sentences:
			$Label.hide()
		else:  # first time we see it
			Game.known_sentences.append(sentence_id)
			has_learnt_the_sentence = true
	else:
		if sentence_id in Game.seen_sentences:
			$Label.hide()
			$LabelSmall.hide()
		else:  # first time we see it
			Game.seen_sentences.append(sentence_id)
			has_seen_the_sentence = true
#		$Label.text = "You've discovered a sentence!"
#		$LabelSmall.text = "It might help you later to guess the meaning of its words"
	$Sentence.init_interactive_sentence(sentence, null, true)
	
func _on_Button_pressed():
	queue_free()
	if has_learnt_the_sentence or has_seen_the_sentence:
		var dialog_text = [
			"""[Name] writes the sentence in the notebook.
Press F to see all your sentences."""
		]
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		Game.current_dialog.init_dialog(dialog_text, self, null, false)
		Game.player.stop_walking()
		Game.current_scene.add_child(Game.current_dialog)
	else:
		Game.can_move = true
		Game.player.can_interact = true
