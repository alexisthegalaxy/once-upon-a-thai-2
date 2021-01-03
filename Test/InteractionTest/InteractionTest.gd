extends CanvasLayer

var interaction_sentence_id
var sentence_id
var sentence
var npc
var lo = TranslationServer.get_locale()

func get_sentence_id():
	if "S" in interaction_sentence_id:
		return interaction_sentence_id.replace("S", "")

func init_interaction_test(_interaction_sentence_id, _npc):
	npc = _npc
	interaction_sentence_id = _interaction_sentence_id
	Game.active_test = self
	sentence_id = get_sentence_id()
	sentence = Game.sentences[sentence_id]
	$InteractiveSentence.init_interactive_sentence(sentence, null, true, true, false)
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

func on_correct():
	SoundPlayer.play_sound("res://Sounds/ding.wav", 0)
	Game.known_sentences.append(int(sentence_id))
	Game.seen_sentences.erase(int(sentence_id))
	Game.active_test = null
	Game.is_frozen = false
	queue_free()
	npc.update_npc_overhead()

func on_incorrect():
	SoundPlayer.play_sound("res://Sounds/incorrect.wav", 0)
	$Input.text = ""

func _on_Submit_pressed():
	if $Input.text == "":
		return
	var correct_answer = sentence[lo].to_upper().replace(".", "").replace("?", "") + " "
	if $Input.text == correct_answer:
		on_correct()
	else:
		on_incorrect()
