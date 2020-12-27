extends CanvasLayer
# Test 1 of a Spell Encounter
var word
var word_id
var alpha = 0
var number_of_choices = 4
var distractors = []  # a list of words
var choices
var over_word
var selected_answer_thai = ""

func set_alpha():
	$Explanation.modulate = Color(1, 1, 1, alpha)
	$Sprite.modulate = Color(1, 1, 1, alpha)

func hide_answers():
	$AudioAnswer1.hide()
	$AudioAnswer2.hide()
	$AudioAnswer3.hide()
	$AudioAnswer4.hide()

func play_audio(word):
	SoundPlayer.play_thai(word.th)

func init(_word_id, _over_word):
	word_id = _word_id
	Game.is_frozen = true
	over_word = _over_word
	word = Game.words[str(word_id)]
	init_learn_letter_button()
	$Word.text = word.th
	distractors = DistractorsHelper.get_words_with_audio_and_about_that_many_characters(len(word.th), number_of_choices - 1, word.th)
	choices = [word] + distractors
	choices.shuffle()
	
	hide_answers()
	if number_of_choices >= 1:
		$AudioAnswer1.init_sound_player(choices[0].th)
		$AudioAnswer1.show()
		$AudioAnswer1.connect("pressed", self, "on_audio_pressed")
	if number_of_choices >= 2:
		$AudioAnswer2.init_sound_player(choices[1].th)
		$AudioAnswer2.show()
		$AudioAnswer2.connect("pressed", self, "on_audio_pressed")
	if number_of_choices >= 3:
		$AudioAnswer3.init_sound_player(choices[2].th)
		$AudioAnswer3.show()
		$AudioAnswer3.connect("pressed", self, "on_audio_pressed")
	if number_of_choices >= 4:
		$AudioAnswer4.init_sound_player(choices[3].th)
		$AudioAnswer4.show()
		$AudioAnswer4.connect("pressed", self, "on_audio_pressed")

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
	# This is the first test of the encounter
	# When it ends, we got to the second test: "res://Test/TestGuessMeaning.tscn"
	SoundPlayer.play_sound("res://Sounds/ding.wav", 0)
	Game.start_test("res://Test/Word/TestGuessMeaning.tscn", word_id, over_word)
	queue_free()
	Game.should_start_test_when_back_from_MP = [null, null]

func answered_wrongly():
	SoundPlayer.play_sound("res://Sounds/incorrect.wav", 0)

func _on_OK_pressed():
	if selected_answer_thai == word.th:
		answered_correctly()
	else:
		answered_wrongly()
