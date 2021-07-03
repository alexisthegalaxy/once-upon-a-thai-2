extends Node2D

var all_words = []  # all Spell instances in the Palace
var links = []  # instance of a WordNetLink

func _ready():
	pass # Replace with function body.

func _init_word_net(_all_words):
	all_words = _all_words
	update_links()

func add_word(word):
	all_words.append(word)
	update_links()

func remove_word(word):
	all_words.erase(word)
	update_links()

func remove_all_links():
	for link in links:
		link.delete()
	links = []

func update_links():
	remove_all_links()
	for word_1 in all_words:
		word_1.links = []
	for word_1 in all_words:
		var related_words = Compound.get_related_words(Game.words[str(word_1.id)].split)
		for word_2 in all_words:
			if word_2.id in related_words:
				var new_link = make_link(word_1, word_2)
				links.append(new_link)
				word_1.links.append(new_link)
				word_2.links.append(new_link)

func make_link(word_1, word_2):
	var new_link = load("res://Palace/WordNet/WordNetLink.tscn").instance()
	Game.current_scene.get_node("YSort").add_child(new_link)
	new_link._init_word_net_link(to_local(word_1.position), to_local(word_2.position))
	new_link.word_1 = word_1
	new_link.word_2 = word_2
	return new_link
