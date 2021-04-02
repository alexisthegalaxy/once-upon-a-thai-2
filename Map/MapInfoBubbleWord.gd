extends Node2D

var word
var word_is_known

func _init_map_info_bubble_word(word_id):
	word = Game.words[str(word_id)]
	$Label.text = word.th
	word_is_known = int(word_id) in Game.known_words
	if not word_is_known:
		$Checkmark.visible = false
