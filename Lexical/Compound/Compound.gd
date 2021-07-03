extends Node

# associates the word to its meaning.
# Constituents are obtained by split("_")
#  "ด้วย_ดี": {
#    "en": "without trouble",
#    "fr": "sans souci"
#  }
var basic_compound_dict = {}

# associates the word to its meaning.
# Constituents are obtained by split("_")
#  "ด้วย": ["ด้วย_ดี", "ประ-กอบ_ด้วย"]
var word_to_compounds_dict = {}


func _ready():
	
	pass # Replace with function body.

func get_components(input):  # -> list[int]
	var related_words = []
	for component in input.split("-"):
		for word_id in Game.words:
			if Game.words[word_id].split == component:
				related_words.append(int(word_id))
	return related_words

func get_related_words(input: String):  # -> list[int]
	if "-" in input:
		return get_components(input)
	var related_word_values = []
	var related_word_ids = []
	for word_id in Game.words:
		var word_split = Game.words[word_id].split
		if "-" in word_split and input in word_split.split("-"):
			for component in word_split.split("-"):
				if component != input:
					related_word_values.append(component)
	for word_id in Game.words:
		for related_word_value in related_word_values:
			if Game.words[word_id].split == related_word_value:
				related_word_ids.append(int(word_id))
	return related_word_ids
