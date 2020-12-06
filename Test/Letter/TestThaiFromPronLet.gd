extends CanvasLayer
# Test 2 of the letter tests
var letter
var alpha = 0
var number_of_choices = 5
var distractors = []  # a list of words 
var choices
var over_letter
var letter_id

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

func init(_letter_id, _over_letter):
	letter_id = _letter_id
	over_letter = _over_letter
	Game.is_frozen = true
	letter = Game.letters[str(letter_id)]
	SoundPlayer.play_thai(letter["audio"])
	$TestSoundPlayer.init_sound_player(letter["audio"])
	$Thai.text = letter[TranslationServer.get_locale()]
	distractors = DistractorsHelper.get_letter_distractors(letter, number_of_choices)
	choices = DistractorsHelper.get_choices(distractors, letter)
	hide_answers()
	if number_of_choices >= 1:
		$answer_1.show()
		$answer_1.init(self, choices[0]["th"], choices[0]["id"] == letter["id"])
	if number_of_choices >= 2:
		$answer_2.show()
		$answer_2.init(self, choices[1]["th"], choices[1]["id"] == letter["id"])
	if number_of_choices >= 3:
		$answer_3.show()
		$answer_3.init(self, choices[2]["th"], choices[2]["id"] == letter["id"])
	if number_of_choices >= 4:
		$answer_4.show()
		$answer_4.init(self, choices[3]["th"], choices[3]["id"] == letter["id"])
	if number_of_choices >= 5:
		$answer_5.show()
		$answer_5.init(self, choices[4]["th"], choices[4]["id"] == letter["id"])
	
func _ready():
	set_alpha()

func _process(delta):
	if alpha < 1:
		alpha += delta * 2
		set_alpha()
	elif alpha > 1:
		alpha = 1
		set_alpha()

func answered_correctly():
	# This is the second test
	# When it ends, we got to the third test: TestThaiFromPronLet16
	Game.start_test("res://Test/Letter/TestThaiFromPronLet16.tscn", letter_id, over_letter)
	queue_free()

