extends CanvasLayer

enum {
	VOWELS,
	LCS,
	MCS,
	HCS,
	ACCENTS,
	NUMBERS,
}
var current_page = VOWELS

const NUMBER_OF_LETTERS_PER_LINE = 3
const NUMBER_OF_DISPLAYED_LINES = 6

var vowels = []
var lcs = []
var mcs = []
var hcs = []
var accents = []
var numbers = []

var displayed_letters = []
var y_bottom = 0
var x_bottom = 0

func s_x(x):
	return x * 32 + 28

func s_y(y):
	return y * 32 + 16 + 16

func _class_name(_class: String):
	if _class == "VOWEL":
		return VOWELS
	if _class == "HIGH":
		return HCS
	if _class == "LOW":
		return LCS
	if _class == "MID":
		return MCS
	if _class == "ACCENT":
		return ACCENTS
	if _class == "NUMBER":
		return NUMBERS

func sort_on_frequency(a, b):
	return a["frequency_index"] < b["frequency_index"]

func get_letters(letter_class):
	var letters = []
	for letter_id in Game.letters:
		var letter = Game.letters[letter_id]
		if _class_name(letter["class"]) == letter_class:
			letters.append(letter)
	return letters
	
func init(_player):
	init_words()
	var label_y = 10
	$VowelsLabel.position = Vector2(s_x(0), label_y)
	$LCLabel.position = Vector2(s_x(NUMBER_OF_LETTERS_PER_LINE + 2), label_y)
	$MCLabel.position = Vector2(s_x(2 * (NUMBER_OF_LETTERS_PER_LINE + 2)), label_y)
	$HCLabel.position = Vector2(s_x(3 * (NUMBER_OF_LETTERS_PER_LINE + 2)), label_y)
	$AccentsLabel.position = Vector2(s_x(4 * (NUMBER_OF_LETTERS_PER_LINE + 2)), label_y)
	$NumbersLabel.position = Vector2(s_x(5 * (NUMBER_OF_LETTERS_PER_LINE + 2)), label_y)
	

func init_words():
	var AlphabetLetter = load("res://Lexical/Alphabet/AlphabetLetter.tscn")
	
	vowels = get_letters(VOWELS)
	lcs = get_letters(LCS)
	mcs = get_letters(MCS)
	hcs = get_letters(HCS)
	accents = get_letters(ACCENTS)
	numbers = get_letters(NUMBERS)
	
	vowels.sort_custom(self, "sort_on_frequency")
	lcs.sort_custom(self, "sort_on_frequency")
	mcs.sort_custom(self, "sort_on_frequency")
	hcs.sort_custom(self, "sort_on_frequency")
	accents.sort_custom(self, "sort_on_frequency")
	numbers.sort_custom(self, "sort_on_frequency")
	
	var class_x = 0
	var x = 0
	var y = 0
	for letter_class in [vowels, lcs, mcs, hcs, accents, numbers]:
		for letter in letter_class:
			var alphabet_letter = AlphabetLetter.instance()
			$Control.add_child(alphabet_letter)
			displayed_letters.append(alphabet_letter)
			alphabet_letter.init(letter)
			alphabet_letter.set_known(Game.knows_letter(letter))
			alphabet_letter.position = Vector2(s_x(x), s_y(y))
			
			x += 1
			if x > NUMBER_OF_LETTERS_PER_LINE + class_x:
				y += 1
				x = class_x
		class_x += NUMBER_OF_LETTERS_PER_LINE + 2
		y = 0
		x = class_x

func _input(event) -> void:
	if event is InputEventPanGesture:
		var x_delta = -event.delta.x
		if x_bottom >= 0 and x_delta > 0:
			return
		x_bottom += x_delta
		for letter in displayed_letters:
			letter.position.x += x_delta
		for label in [$VowelsLabel, $LCLabel, $MCLabel, $HCLabel, $AccentsLabel, $NumbersLabel]:
			label.position.x += x_delta
