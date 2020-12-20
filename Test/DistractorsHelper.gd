extends Node
# Reminder: choices = distractors + answer

func _ready():
	randomize()

var lo = TranslationServer.get_locale()
# this function returns distractors, not distractors ids
func get_letter_distractors(letter, number_of_choices):
	# if the JSON letter contains the field letters:
	var distractors = []
	if "distractors" in letter:
		for distractor_id in letter.distractors:
			distractors.append(Game.letters[str(distractor_id)])
	while len(distractors) < number_of_choices - 1:
		var random_letter = Game.letters[str(randi() % Game.letters.size())]
		if random_letter[lo] != letter[lo] and random_letter.th != letter.th and not random_letter in distractors:
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
		var random_word = Game.words[str(randi() % Game.words.size())]
		if random_word.th != word.th and random_word[lo] != word[lo] and not random_word in distractors:
			distractors.append(random_word)
	return distractors

func get_choices(distractors, answer):
	var choices = []
	for distractor in distractors:
		choices.append(distractor)
	choices.append(answer)
	choices.shuffle()
	return choices

func fragment_sentence_into_three(sentence):
	var words_in_sentence = sentence[lo].to_upper().replace(".", "").replace("?", "").split(" ")
	var number_of_words_in_sentence = len(words_in_sentence)
	var number_of_words_per_fragment = ceil(number_of_words_in_sentence / 3.0)
	var correct_fragment_0 = ""
	var correct_fragment_1 = ""
	var correct_fragment_2 = ""
	var word_index_per_fragment = 0
	var correct_fragment_index = 0
	for word_in_sentence in words_in_sentence:
		if word_index_per_fragment == number_of_words_per_fragment:
			word_index_per_fragment = 0
			correct_fragment_index += 1

		if correct_fragment_index == 0:
			correct_fragment_0 += word_in_sentence + " "
		if correct_fragment_index == 1:
			correct_fragment_1 += word_in_sentence + " "
		if correct_fragment_index == 2:
			correct_fragment_2 += word_in_sentence + " "
		word_index_per_fragment += 1
	return [correct_fragment_0, correct_fragment_1, correct_fragment_2]

func get_random_from_dict(dict):
   var dict_keys = dict.keys()
   return dict_keys[randi() % dict_keys.size()]

func get_random(array):
	return array[randi() % array.size()]

func get_sentences_fragments(sentence, number_of_options):
	assert (len(Game.seen_sentences) + len(Game.known_sentences) > 5)
	var choices = fragment_sentence_into_three(sentence)
	while len(choices) < number_of_options:
		var incorrect_sentence_id = get_random(Game.seen_sentences + Game.known_sentences)
		var incorrect_sentence = Game.sentences[str(incorrect_sentence_id)]
		var incorrect_fragments = fragment_sentence_into_three(incorrect_sentence)
		for incorrect_fragment in incorrect_fragments:
			if incorrect_fragment and len(choices) < number_of_options and not incorrect_fragment in choices:
				choices.append(incorrect_fragment)
	choices.shuffle()
	return choices

func get_words_to_review(number_of_words_to_review):
	var words_to_return = []
	if number_of_words_to_review > len(Game.known_words):
		print("error: we know ", len(Game.known_words), " but we want ", number_of_words_to_review, " words in get_words_to_review.")
		return []
	while len(words_to_return) < number_of_words_to_review:
		var random_word = Game.known_words[randi() % len(Game.known_words)]
		if not random_word in words_to_return:
			words_to_return.append(random_word)
	return words_to_return

func get_words_with_audio_and_about_that_many_characters(size, distractors_number):
	var words_with_audio = []
	var file = File.new()
	for word_id in Game.words:
		var word = Game.words[word_id]
		var has_audio = file.file_exists(SoundPlayer.get_audio_file_path_from_thai(word.th))
		words_with_audio.append(word)

	var remaining_number_of_words_to_select = distractors_number
	var selected_words = []
	for closeness in [0, -1, 1, -2, 2, -3, 3, -4, 4, -5, 5, -6, 6, -7, 7, -8, 8]:
		selected_words += select_words_with_that_amount_of_letters(words_with_audio, size - closeness, remaining_number_of_words_to_select)
		remaining_number_of_words_to_select = distractors_number - len(selected_words)
		print('closeness', closeness, 'remaining_number_of_words_to_select', remaining_number_of_words_to_select)

	print('selected_words (there should only be ', distractors_number, ')')
	for selected_word in selected_words:
		print('    ', selected_word.th)
	return selected_words

func select_words_with_that_amount_of_letters(words, size, number_of_words_to_select):
	if number_of_words_to_select <= 0:
		return []
	var words_with_right_amount_of_letters = []
	for word in words:
		if len(word.th) == size:
			words_with_right_amount_of_letters.append(word)

	var selected_words = []
	while len(selected_words) < min(len(words_with_right_amount_of_letters), size):
		var random_word = words_with_right_amount_of_letters[randi() % len(words_with_right_amount_of_letters)]
		if not random_word in selected_words:
			selected_words.append(random_word)
	return selected_words
