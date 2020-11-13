extends CanvasLayer
# Test 4 of the letter tests
var letter
var letter_id
var alpha = 0
var number_of_choices = 5
var distractors = []  # a list of words 
var rng = RandomNumberGenerator.new()
var choices
var over_letter

func set_alpha():
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
	distractors = letter["test"]["distractors"]
	number_of_choices = len(distractors) + 1
#	if "distractors" in letter:
#		for distractor_id in letter["distractors"]:
#			distractors.append(Game.letters[str(distractor_id)])
#	while len(distractors) < number_of_choices - 1:
#		var random_letter = Game.letters[str(rng.randi() % Game.letters.size())]
#		distractors.append(random_letter)

func set_choices():
	choices = []
	for distractor in distractors:
		choices.append(distractor)
	choices.append(letter["test"]["prompt"])
	choices.shuffle()

func play_audio():
	SoundPlayer.play_thai(letter["test"]["prompt"])

func play_audio_after_one_second():
	var timer = Timer.new()
	timer.connect("timeout", self, "play_audio")
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	timer.autostart = true
	timer.start()
	add_child(timer)

func init(_letter_id, _over_letter):
	letter_id = _letter_id
	Game.can_move = false
	over_letter = _over_letter
	rng.randomize()
	letter = Game.letters[str(letter_id)]
	
	if not "test" in letter:
		answered_correctly()
		return
	# TODO
	play_audio_after_one_second()
	
	$TestSoundPlayer.init(letter["test"]["prompt"])
	set_distractors()
	set_choices()
	hide_answers()
#	print('choices', choices)
	if number_of_choices >= 1:
		$answer_1.show()
		$answer_1.init(self, choices[0], choices[0] == letter["test"]["prompt"])
	if number_of_choices >= 2:
		$answer_2.show()
		$answer_2.init(self, choices[1], choices[1] == letter["test"]["prompt"])
	if number_of_choices >= 3:
		$answer_3.show()
		$answer_3.init(self, choices[2], choices[2] == letter["test"]["prompt"])
	if number_of_choices >= 4:
		$answer_4.show()
		$answer_4.init(self, choices[3], choices[3] == letter["test"]["prompt"])
	if number_of_choices >= 5:
		$answer_5.show()
		$answer_5.init(self, choices[4], choices[4] == letter["test"]["prompt"])
	if number_of_choices >= 6:
		$answer_6.show()
		$answer_6.init(self, choices[5], choices[5] == letter["test"]["prompt"])
	if number_of_choices >= 7:
		$answer_7.show()
		$answer_7.init(self, choices[6], choices[6] == letter["test"]["prompt"])

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
	# This is the fourth and currently last test
#	Game.can_move = true
	Game.active_test = null
	Game.is_frozen = false
#	Game.player.can_interact = true
	Game.learn_letter(letter)
	over_letter.starts_disappearing()
	Game.dialog_press_f_to_see_it('letter')
	if Game.looking_for_letter__node:
		Game.looking_for_letter__node.get_node("Node2D").show()
	queue_free()

