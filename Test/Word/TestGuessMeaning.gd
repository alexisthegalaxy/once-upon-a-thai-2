extends CanvasLayer

var word
var alpha = 0
var number_of_choices = 5
var distractors = []  # a list of words 
var choices
var over_word

func set_alpha():
	$Thai.modulate = Color(1, 1, 1, alpha)
	$Explanation.modulate = Color(1, 1, 1, alpha)
	$Sprite.modulate = Color(1, 1, 1, alpha)

func hide_answers():
	$answer_1.hide()
	$answer_2.hide()
	$answer_3.hide()
	$answer_4.hide()
	$answer_5.hide()
	$answer_6.hide()
	$answer_7.hide()

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

func leaves_test_to_go_to_MP():
	# We need to reopen the test when we're back.
	Game.should_start_test_when_back_from_MP = [
		"res://Test/Word/TestGuessMeaning.tscn",
		word["id"],
		over_word,
	]
	over_word.is_frozen = true

func init(word_id, _over_word):
	Game.is_frozen = true
	Game.active_test = self
	over_word = _over_word
	word = Game.words[str(word_id)]
	SoundPlayer.play_thai(word["th"])
	init_learn_letter_button()
	$Thai.text = word["th"]
	distractors = DistractorsHelper.get_word_distractors(word, number_of_choices)
	choices = DistractorsHelper.get_choices(distractors, word)
	hide_answers()
	if number_of_choices >= 1:
		$answer_1.show()
		$answer_1.init(self, choices[0][TranslationServer.get_locale()], choices[0]["id"] == word["id"])
	if number_of_choices >= 2:
		$answer_2.show()
		$answer_2.init(self, choices[1][TranslationServer.get_locale()], choices[1]["id"] == word["id"])
	if number_of_choices >= 3:
		$answer_3.show()
		$answer_3.init(self, choices[2][TranslationServer.get_locale()], choices[2]["id"] == word["id"])
	if number_of_choices >= 4:
		$answer_4.show()
		$answer_4.init(self, choices[3][TranslationServer.get_locale()], choices[3]["id"] == word["id"])
	if number_of_choices >= 5:
		$answer_5.show()
		$answer_5.init(self, choices[4][TranslationServer.get_locale()], choices[4]["id"] == word["id"])
	
	$SentenceCarousel.init_sentence_carousel(word_id)
	
func _ready():
	set_alpha()
	$SentenceCarousel.hide()
	$Button.show()

func _process(delta):
	if alpha < 1:
		alpha += delta * 2
		set_alpha()
	elif alpha > 1:
		alpha = 1
		set_alpha()

func answered_correctly():
	# This is the first test of the encounter
	# When it ends, we got to the second test: "res://Test/TestGuessMeaning.tscn"
	SoundPlayer.play_sound("res://Sounds/ding.wav", 0)
	Game.start_test("res://Test/Word/TestWordCopyTyping.tscn", word.id, over_word)
	queue_free()
	Game.should_start_test_when_back_from_MP = [null, null]
	
func _on_Button_pressed():
	$SentenceCarousel.show()
