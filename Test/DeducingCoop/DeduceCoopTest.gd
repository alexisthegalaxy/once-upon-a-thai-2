extends CanvasLayer

var sentence_id
var sentence
var lo = TranslationServer.get_locale()

func init_deduce_coop_test(_sentence_id):
	Game.deducing_coop_select_sentence_screen.queue_free()
	Game.deducing_coop_select_sentence_screen = null
	sentence_id = str(_sentence_id)
	sentence = Game.sentences[sentence_id]
	Game.active_test = self
	$InteractiveSentence.init_interactive_sentence(sentence, null, false, false, false)
	var sentences_fragments = DistractorsHelper.get_sentences_fragments(sentence, 9)
	$Button0.text = sentences_fragments[0]
	$Button1.text = sentences_fragments[1]
	$Button2.text = sentences_fragments[2]
	$Button3.text = sentences_fragments[3]
	$Button4.text = sentences_fragments[4]
	$Button5.text = sentences_fragments[5]
	$Button6.text = sentences_fragments[6]
	$Button7.text = sentences_fragments[7]
	$Button8.text = sentences_fragments[8]


func _on_Button0_pressed():
	$Input.text += $Button0.text

func _on_Button1_pressed():
	$Input.text += $Button1.text

func _on_Button2_pressed():
	$Input.text += $Button2.text

func _on_Button3_pressed():
	$Input.text += $Button3.text

func _on_Button4_pressed():
	$Input.text += $Button4.text

func _on_Button5_pressed():
	$Input.text += $Button5.text

func _on_Button6_pressed():
	$Input.text += $Button6.text

func _on_Button7_pressed():
	$Input.text += $Button7.text

func _on_Button8_pressed():
	$Input.text += $Button8.text

func _on_Cross_pressed():
	$Input.text = ""

func _on_Submit_pressed():
	if $Input.text == "":
		return
	var correct_answer = sentence[lo].to_upper().replace(".", "").replace("?", "") + " "
	print("___", correct_answer, "___")
	print("___", $Input.text, "___")
	if $Input.text == correct_answer:
		SoundPlayer.play_sound("res://Sounds/ding.wav")
		Game.known_sentences.append(int(sentence_id))
		Game.seen_sentences.erase(int(sentence_id))
		Game.active_test = null
#		Game.is_frozen = false
		queue_free()
		Game.starts_deducing_coop()
		
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		var dialog = [tr("_hmm_yeah_i_thnk_this_is_the_sentence")]
		Game.current_dialog.init_dialog(dialog, self, null, false, 'Ploy')
		Game.current_scene.add_child(Game.current_dialog)
#		Game.deducing_coop_select_sentence_screen.queue_free()
#		Game.deducing_coop_select_sentence_screen = null
	else:
		SoundPlayer.play_sound("res://Sounds/incorrect.wav")
		$Input.text = ""
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		var dialog = [tr("_hmm_no_i_think_its_a_different_sentence")]
		Game.current_dialog.init_dialog(dialog, self, null, false, 'Ploy')
		Game.current_scene.add_child(Game.current_dialog)
