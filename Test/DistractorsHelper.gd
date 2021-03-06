extends Node
# Reminder: choices = distractors + answer

const PLACEHOLDER = "___PLACEHOLDER___"

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
	var words_in_sentence = clean_sentence(get_sentence_source_text(sentence).to_upper()).split(" ")
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

func get_words_with_audio_and_about_that_many_characters(size, distractors_number, original_to_avoid):
	var words_with_audio = []
	for word_id in Game.words:
		var word = Game.words[word_id]
		var has_audio = SoundPlayer.has_audio(word.th)
		if has_audio:
			words_with_audio.append(word)
	var remaining_number_of_words_to_select = distractors_number
	var selected_words = []
	for closeness in [0, -1, 1, -2, 2, -3, 3, -4, 4, -5, 5, -6, 6, -7, 7, -8, 8]:
		for new_distractor in select_words_with_that_amount_of_letters(words_with_audio, size - closeness, remaining_number_of_words_to_select):
			if len(selected_words) < distractors_number and new_distractor.th != original_to_avoid:
				selected_words.append(new_distractor)
		remaining_number_of_words_to_select = distractors_number - len(selected_words)

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

func process_bracket_content(bracket_content):
	print('bracket_content: ', bracket_content)
	if len(bracket_content) < 2:
		return ""
	for section in bracket_content.split("; "):
		if section[0].to_upper() == Game.player_gender.to_upper():
			return section.split(":")[1]
	return ""

func process_player_gender_in_sentence(sentence):
	var result = ""
	var bracket_content = ""
	var in_bracket = false
	for letter in sentence:
		if letter == "[":
			in_bracket = true
			bracket_content = ""
			result += PLACEHOLDER
		elif letter == "]":
			in_bracket = false
			print('genre processed: ', process_bracket_content(bracket_content))
			print('result: ', result)
			result = result.replace(PLACEHOLDER, process_bracket_content(bracket_content))
		else:
			if in_bracket:
				bracket_content += letter
			else:
				result += letter
	return result

func clean_sentence(_sentence):
#	var inside_parentheses = false
	var sentence = _sentence.to_upper().replace(".", "").replace("-", " ")
	sentence = sentence.replace("!", "").replace(",", "")
	sentence = sentence.replace("?", "").replace("ʼ", "'")
#	sentence = sentence.replace("ï", "i").replace("ç", "c")
	sentence = sentence.replace("Ï", "I").replace("Î", "I")
	sentence = sentence.replace("Ò", "O").replace("Ó", "O").replace("Ô", "O").replace("Ö", "O")
	sentence = sentence.replace("Û", "U").replace("Ü", "U").replace("Ù", "U").replace("Ú", "U")
	sentence = sentence.replace("È", "E").replace("É", "E").replace("Ê", "E").replace("Ë", "E")
	sentence = sentence.replace("Ç", "C")
#	sentence = sentence.replace("è", "e").replace("é", "e").replace("ê", "e")
	sentence = sentence
#	var result = ""
#	for letter in sentence:
#		if letter == "(":
#			inside_parentheses = true
#		elif letter == ")":
#			inside_parentheses = false
#		elif not inside_parentheses:
#			result += letter
	return process_player_gender_in_sentence(sentence.strip_edges(true, true))

func fragment_sentence_into_words(sentence):
	var words_in_sentence = clean_sentence(get_sentence_source_text(sentence).to_upper()).split(" ")
	return words_in_sentence

func get_distractors_for_words_in_sentence(sentence, number_of_options):
	var choices = Array(fragment_sentence_into_words(sentence))
	while len(choices) < number_of_options:
		var incorrect_sentence_id
		if len(Game.seen_sentences) + len(Game.known_sentences) > 5:
			incorrect_sentence_id = get_random(Game.seen_sentences + Game.known_sentences)
		else:
			incorrect_sentence_id = str(randi() % Game.sentences.size())
		var incorrect_sentence = Game.sentences[str(incorrect_sentence_id)]
		# TODO 2838: Add "if sentence is translated in our source language"
		var incorrect_fragments = fragment_sentence_into_words(incorrect_sentence)
		for incorrect_fragment in incorrect_fragments:
			if incorrect_fragment and len(choices) < number_of_options and not incorrect_fragment in choices:
				choices.append(incorrect_fragment)
	choices.shuffle()
	return choices

func explode_curly_braces(s):
#	s = "0-{1a/1b}-2-{3a/3b}-4"
	if not "{" in s:
		return [s]
	
	var alternatives = [""]
	var members
	var member_index
	var member_active = false
	for character in s:
		if character == "{":
			members = [""]
			member_index = 0
			member_active = true
		elif character == "/":
			members.append("")
			member_index += 1
		elif character == "}":
			member_active = false
			var new_alternatives = []
			for alternative in alternatives:
				for member in members:
					new_alternatives.append(alternative + member)
			alternatives = new_alternatives
		else:
			if member_active:
				members[member_index] += character
			else:
				for i in len(alternatives):
					alternatives[i] = alternatives[i] + character
				
	return alternatives

func explode_parenthesis(s):
	if not "(" in s:
		return [s]
	var alternatives = [""]
	var is_inside_par = false
	var inside_text
	for character in s:
		if character == "(":
			is_inside_par = true
			inside_text = ""
		elif character == ")":
			is_inside_par = false
			var new_alternatives = []
			for alternative in alternatives:
				new_alternatives.append(alternative + inside_text)
				new_alternatives.append(alternative)
			alternatives = new_alternatives
		else:
			if is_inside_par:
				inside_text += character
			else:
				for i in len(alternatives):
					alternatives[i] = alternatives[i] + character
	return alternatives

func get_sentence_source_text(sentence):
	# This returns the first alternative found.
	# This means the first element of the ones separated by |
	# This means the first element in each {} clause
	# We take evrything that appears in parenthesis
	return get_sl_sentence_alternatives(sentence[lo])[0]

func get_sl_sentence_alternatives(sl_string):
	print(sl_string)
	# Step 1: explode on the |
	var alternatives_bar = sl_string.split("|")
	# Step 2: explode the { and }
	var alternatives_curly = []
	for alternative_bar in alternatives_bar:
		alternatives_curly += explode_curly_braces(alternative_bar)
	# Step 3: explode the ()
	var alternatives_parenthesis = []
	for alternative_curly in alternatives_curly:
		alternatives_parenthesis += explode_parenthesis(alternative_curly)
	return alternatives_parenthesis

