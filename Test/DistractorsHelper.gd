extends Node
# Reminder: choices = distractors + answer

var rng = RandomNumberGenerator.new()

# this function returns distractors, not distractors ids
func get_letter_distractors(letter, number_of_choices):
	# if the JSON letter contains the field letters:
	var distractors = []
	if "distractors" in letter:
		for distractor_id in letter.distractors:
			distractors.append(Game.letters[str(distractor_id)])
	while len(distractors) < number_of_choices - 1:
		var random_letter = Game.letters[str(rng.randi() % Game.letters.size())]
		if random_letter.id != letter.id and not random_letter in distractors:
			distractors.append(random_letter)
	return distractors

# this function returns distractors, not distractors ids
func get_word_distractors(word, number_of_choices):
	var distractors = []
	# if the JSON letter contains the field letters:
	if "distractors" in word:
		for distractor_id in word["distractors"]:
			distractors.append(Game.words[str(distractor_id)])
	while len(distractors) < number_of_choices - 1:
		var random_word = Game.words[str(rng.randi() % Game.words.size())]
		if random_word.id != word.id and not random_word in distractors:
			distractors.append(random_word)
	return distractors

func get_choices(distractors, answer):
	var choices = []
	for distractor in distractors:
		choices.append(distractor)
	choices.append(answer)
	choices.shuffle()
	return choices
