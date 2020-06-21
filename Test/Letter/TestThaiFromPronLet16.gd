extends CanvasLayer
# Test 3 of the letter tests
var letter
var letter_id
var alpha = 0
var number_of_choices = 16
var distractors = []  # a list of words 
var rng = RandomNumberGenerator.new()
var choices
var over_letter

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
	$answer_8.hide()
	$answer_9.hide()
	$answer_10.hide()
	$answer_11.hide()
	$answer_12.hide()
	$answer_13.hide()
	$answer_14.hide()
	$answer_15.hide()
	$answer_16.hide()

func set_distractors():
	if "distractors" in letter:
		for distractor_id in letter["distractors"]:
			distractors.append(Game.letters[str(distractor_id)])
	while len(distractors) < number_of_choices - 1:
		var random_letter = Game.letters[str(rng.randi() % Game.letters.size())]
		distractors.append(random_letter)

func set_choices():
	choices = []
	for distractor in distractors:
		choices.append(distractor)
	choices.append(letter)
	choices.shuffle()

func init(_letter_id, _over_letter):
	letter_id = _letter_id
	over_letter = _over_letter
	Game.can_move = false
	rng.randomize()
	letter = Game.letters[str(letter_id)]
	SoundPlayer.play_thai(letter["audio"])
	$Thai.text = letter["en"]
	set_distractors()
	set_choices()
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
	if number_of_choices >= 6:
		$answer_6.show()
		$answer_6.init(self, choices[5]["th"], choices[5]["id"] == letter["id"])
	if number_of_choices >= 7:
		$answer_7.show()
		$answer_7.init(self, choices[6]["th"], choices[6]["id"] == letter["id"])
	if number_of_choices >= 8:
		$answer_8.show()
		$answer_8.init(self, choices[7]["th"], choices[7]["id"] == letter["id"])
	if number_of_choices >= 9:
		$answer_9.show()
		$answer_9.init(self, choices[8]["th"], choices[8]["id"] == letter["id"])
	if number_of_choices >= 10:
		$answer_10.show()
		$answer_10.init(self, choices[9]["th"], choices[9]["id"] == letter["id"])
	if number_of_choices >= 11:
		$answer_11.show()
		$answer_11.init(self, choices[10]["th"], choices[10]["id"] == letter["id"])
	if number_of_choices >= 12:
		$answer_12.show()
		$answer_12.init(self, choices[11]["th"], choices[11]["id"] == letter["id"])
	if number_of_choices >= 13:
		$answer_13.show()
		$answer_13.init(self, choices[12]["th"], choices[12]["id"] == letter["id"])
	if number_of_choices >= 14:
		$answer_14.show()
		$answer_14.init(self, choices[13]["th"], choices[13]["id"] == letter["id"])
	if number_of_choices >= 15:
		$answer_15.show()
		$answer_15.init(self, choices[14]["th"], choices[14]["id"] == letter["id"])
	if number_of_choices >= 16:
		$answer_16.show()
		$answer_16.init(self, choices[15]["th"], choices[15]["id"] == letter["id"])
	
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
	#	This is the third test
	print("16 answered correctly!")
	Game.start_test("res://Test/Letter/TestWordFromSound.tscn", letter_id, over_letter)
	queue_free()


func _on_Button_pressed():
	$SentenceCarousel.show()
