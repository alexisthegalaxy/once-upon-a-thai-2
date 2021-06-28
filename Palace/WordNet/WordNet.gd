extends Node2D

var all_words = []  # instance of a Spell in the Palace
var links = []  # instance of a WordNetLink

func _ready():
	pass # Replace with function body.

func _init(_all_words):
	all_words = _all_words

func add_word(word):
	all_words.append(word)
	update_links()

func update_links():
	for word_1 in all_words:
		for word_2 in all_words:
			if words_are_linked(word_1, word_2):
				links += make_link(word_1, word_2)

func make_link(word_1, word_2):
	return []  # TODO

func words_are_linked(word_1, word_2):
	if word_1.id == word_2.id:
		return false
	return true  # TODO
