extends CanvasLayer

var interaction_sentence_id
var sentence_id
var sentence
var npc
var sentences_fragments
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
	sentences_fragments = DistractorsHelper.get_distractors_for_words_in_sentence(sentence, 15)
	
	$Button0.text = sentences_fragments[0]
	$Button1.text = sentences_fragments[1]
	$Button2.text = sentences_fragments[2]
	$Button3.text = sentences_fragments[3]
	$Button4.text = sentences_fragments[4]
	$Button5.text = sentences_fragments[5]
	$Button6.text = sentences_fragments[6]
	$Button7.text = sentences_fragments[7]
	$Button8.text = sentences_fragments[8]
	$Button9.text = sentences_fragments[9]
	$Button10.text = sentences_fragments[10]
	$Button11.text = sentences_fragments[11]
	$Button12.text = sentences_fragments[12]
	$Button13.text = sentences_fragments[13]
	$Button14.text = sentences_fragments[14]
	$Button0.connect("pressed", self, "on_button_pressed", [$Button0])
	$Button1.connect("pressed", self, "on_button_pressed", [$Button1])
	$Button2.connect("pressed", self, "on_button_pressed", [$Button2])
	$Button3.connect("pressed", self, "on_button_pressed", [$Button3])
	$Button4.connect("pressed", self, "on_button_pressed", [$Button4])
	$Button5.connect("pressed", self, "on_button_pressed", [$Button5])
	$Button6.connect("pressed", self, "on_button_pressed", [$Button6])
	$Button7.connect("pressed", self, "on_button_pressed", [$Button7])
	$Button8.connect("pressed", self, "on_button_pressed", [$Button8])
	$Button9.connect("pressed", self, "on_button_pressed", [$Button9])
	$Button10.connect("pressed", self, "on_button_pressed", [$Button10])
	$Button11.connect("pressed", self, "on_button_pressed", [$Button11])
	$Button12.connect("pressed", self, "on_button_pressed", [$Button12])
	$Button13.connect("pressed", self, "on_button_pressed", [$Button13])
	$Button14.connect("pressed", self, "on_button_pressed", [$Button14])

func on_button_pressed(button):
	$Input.text += button.text + " "
	button.hide()

func _on_Cross_pressed():
	reset_text()

func _ready():
	$Input.grab_focus()

func on_correct():
	SoundPlayer.play_sound("res://Sounds/Effects/correct.wav", 0)
	Game.known_sentences.append(int(sentence_id))
	Game.seen_sentences.erase(int(sentence_id))
	Game.active_test = null
	Game.is_frozen = false
	queue_free()
	npc.update_npc_overhead()

func reset_text():
	$Input.text = ""
	$Button0.show()
	$Button1.show()
	$Button2.show()
	$Button3.show()
	$Button4.show()
	$Button5.show()
	$Button6.show()
	$Button7.show()
	$Button8.show()
	$Button9.show()
	$Button10.show()
	$Button11.show()
	$Button12.show()
	$Button13.show()
	$Button14.show()

func on_incorrect():
	SoundPlayer.play_sound("res://Sounds/Effects/wrong.wav", 0)
	reset_text()

func _on_Submit_pressed():
	if $Input.text == "":
		return
	var is_correct = false
	var cleaned_input = DistractorsHelper.clean_sentence($Input.text)
	print('cleaned_input')
	print(cleaned_input)
	for accepted_answer in DistractorsHelper.get_sl_sentence_alternatives(sentence[lo].to_upper()):
		if DistractorsHelper.clean_sentence(accepted_answer) == cleaned_input:
			is_correct = true
	if is_correct:
		on_correct()
	else:
		on_incorrect()


func _on_GiveUp_pressed():
	SoundPlayer.play_sound("res://Sounds/Effects/wrong.wav", 0)
#	Game.known_sentences.append(int(sentence_id))
#	Game.seen_sentences.erase(int(sentence_id))
	Game.active_test = null
	Game.is_frozen = false
	queue_free()
#	npc.update_npc_overhead()


func _on_Input_text_changed(new_text):
	for i in range(sentences_fragments.size()):
		if sentences_fragments[i] in DistractorsHelper.clean_sentence(new_text):
			get_node("Button" + str(i)).hide()
		else:
			get_node("Button" + str(i)).show()
	# new_text is the full content of the lineEdit
	pass


func _on_Input_text_entered(new_text):
	# When we press enter
	_on_Submit_pressed()
