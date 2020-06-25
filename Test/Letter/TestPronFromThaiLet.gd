extends CanvasLayer
# Test 1 of the letter tests
var letter
var letter_id
var alpha = 0
var number_of_choices = 5
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
	Game.can_move = false
	over_letter = _over_letter
	rng.randomize()
	letter = Game.letters[str(letter_id)]
	$Thai.text = letter["th"]
	set_distractors()
	set_choices()
	hide_answers()
	if number_of_choices >= 1:
		$answer_1.show()
		$answer_1.init(self, choices[0]["en"], choices[0]["id"] == letter["id"])
	if number_of_choices >= 2:
		$answer_2.show()
		$answer_2.init(self, choices[1]["en"], choices[1]["id"] == letter["id"])
	if number_of_choices >= 3:
		$answer_3.show()
		$answer_3.init(self, choices[2]["en"], choices[2]["id"] == letter["id"])
	if number_of_choices >= 4:
		$answer_4.show()
		$answer_4.init(self, choices[3]["en"], choices[3]["id"] == letter["id"])
	if number_of_choices >= 5:
		$answer_5.show()
		$answer_5.init(self, choices[4]["en"], choices[4]["id"] == letter["id"])
	
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
	# This is the first test
	# When it ends, we got to the second test: TestThaiFromPronLet
	Game.start_test("res://Test/Letter/TestThaiFromPronLet.tscn", letter_id, over_letter)
	queue_free()