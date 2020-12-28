extends CanvasLayer
# Test 5 of a Spell Encounter
var word
var word_id
var alpha = 0
var number_of_choices = 4
var distractors = []  # a list of words
var choices
var over_word
var selected_answer_thai = ""
var lo = TranslationServer.get_locale()

func set_alpha():
	$Explanation.modulate = Color(1, 1, 1, alpha)
	$Sprite.modulate = Color(1, 1, 1, alpha)

func hide_answers():
	$AudioAnswer1.hide()
	$AudioAnswer2.hide()
	$AudioAnswer3.hide()
	$AudioAnswer4.hide()

func init(_word_id, _over_word):
	word_id = _word_id
	Game.is_frozen = true
	over_word = _over_word
	word = Game.words[str(word_id)]
#	init_learn_letter_button()
	$English.text = word[lo]
	$Answer.text = ""
	$Keyboard.init_keyboard(false)
	$Keyboard.connect("text_change", self, "on_text_change")

func on_text_change(text):
	$Answer.text = text

func init_learn_letter_button():
	var unknown_letter_ids = []
	if "letters" in word:
		for letter_id in word["letters"]:
			if not letter_id in Game.known_letters:
				unknown_letter_ids.append(letter_id)
	if unknown_letter_ids:
		$LearnLetterButton.init(unknown_letter_ids, self)
	else:
		$LearnLetterButton.queue_free()

func on_audio_pressed(thai):
	selected_answer_thai = thai
	for audio_answer in [$AudioAnswer1, $AudioAnswer2, $AudioAnswer3, $AudioAnswer4]:
		if audio_answer.thai == thai:
			audio_answer.modulate = Color(0.5, 1, 0.5, 1)
		else:
			audio_answer.modulate = Color(1, 1, 1, 1)

func _ready():
	set_alpha()

func _process(delta):
	if alpha < 1:
		alpha += delta * 2
		set_alpha()
	elif alpha > 1:
		alpha = 1
		set_alpha()

func leaves_test_to_go_to_MP():
	# We need to reopen the test when we're back.
	Game.should_start_test_when_back_from_MP = [
		"res://Test/Word/TestSoundFromWord.tscn",
		word["id"],
		over_word,
	]
	over_word.is_frozen = true

func answered_correctly():
#	Game.active_test = null
	SoundPlayer.play_thai(word.th)
	Game.player.can_interact = true
	Game.is_frozen = false
	Game.learn_word(word.id)
	Game.add_following_spell(word.id, over_word)
	
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	var lines = [tr("_you_have_befriended_that_spell") % word.th]
	if len(Game.known_words) == 1:
		lines.append(tr("_press_f_to_open_your_dictionary_and_see_that_word"))
	Game.current_dialog.init_dialog(lines, null, null, null, null)
	Game.current_scene.add_child(Game.current_dialog)
	
	queue_free()
	Game.should_start_test_when_back_from_MP = [null, null]

func answered_wrongly():
	SoundPlayer.play_sound("res://Sounds/incorrect.wav", 0)

func _on_OK_pressed():
	if $Answer.text == word.th:
		answered_correctly()
	else:
		answered_wrongly()

func _on_Hint_mouse_entered():
	SoundPlayer.play_thai(word.th)
	$Hint.text = word.th

func _on_Hint_mouse_exited():
	SoundPlayer.play_thai(word.th)
	$Hint.text = tr("_hint")
