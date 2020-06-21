extends CanvasLayer

var word
var alpha = 0
var number_of_choices = 5
var distractors = []  # a list of words 
var rng = RandomNumberGenerator.new()
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

func set_distractors():
	if "distractors" in word:
		for distractor_id in word["distractors"]:
			distractors.append(Game.words[str(distractor_id)])
	while len(distractors) < number_of_choices - 1:
		var random_word = Game.words[str(rng.randi() % Game.words.size())]
		distractors.append(random_word)

func set_choices():
	choices = []
	for distractor in distractors:
		choices.append(distractor)
	choices.append(word)
	choices.shuffle()

func init(word_id, _over_word):
	Game.can_move = false
	Game.active_test = self
	over_word = _over_word
	rng.randomize()
	word = Game.words[str(word_id)]
	$Thai.text = word["th"]
	set_distractors()
	set_choices()
	hide_answers()
	if number_of_choices >= 1:
		$answer_1.show()
		$answer_1.init(self, choices[0]["en"], choices[0]["id"] == word["id"])
	if number_of_choices >= 2:
		$answer_2.show()
		$answer_2.init(self, choices[1]["en"], choices[1]["id"] == word["id"])
	if number_of_choices >= 3:
		$answer_3.show()
		$answer_3.init(self, choices[2]["en"], choices[2]["id"] == word["id"])
	if number_of_choices >= 4:
		$answer_4.show()
		$answer_4.init(self, choices[3]["en"], choices[3]["id"] == word["id"])
	if number_of_choices >= 5:
		$answer_5.show()
		$answer_5.init(self, choices[4]["en"], choices[4]["id"] == word["id"])
	
	$SentenceCarousel.init(word_id)
	
func _ready():
	set_alpha()
	$SentenceCarousel.hide()

func _process(delta):
	if alpha < 1:
		alpha += delta * 2
		set_alpha()
	elif alpha > 1:
		alpha = 1
		set_alpha()

func answered_correctly():
	Game.can_move = true
	Game.active_test = null
	Game.known_words.append(word["id"])
	over_word.starts_disappearing()
	queue_free()

func _on_Button_pressed():
	$SentenceCarousel.show()
