extends CanvasLayer

var has_learnt_the_sentence = "false"

func init(sentence_id, is_translated):
	if is_translated:
		if not sentence_id in Game.known_sentences:
			Game.known_sentences.append(sentence_id)
			has_learnt_the_sentence = true
		$Label.text = "You've learned a sentence!"
		$LabelSmall.text = ""
	else:
		$Label.text = "You've discovered a sentence!"
		$LabelSmall.text = "It might help you later to guess the meaning of its words"
	$Sentence.init(Game.sentences[str(sentence_id)], null)
	
func _on_Button_pressed():
	queue_free()
	if has_learnt_the_sentence:
		var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
		var dialog = [
			"""You've learnt a new sentence!
Press f to see your sentence."""
		]
		ui_dialog.init(dialog, Game.player, self, null, false)
		Game.player.stop_walking()
		get_tree().current_scene.add_child(ui_dialog)
	else:
		Game.can_move = true
		Game.player.can_interact = true
