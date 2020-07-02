extends Node2D

var words = []
var children = []

func init(sentence, main_word_id):
	var current_x = 0
	for child in children:
		child.queue_free()
	children = []
	if sentence["id"] in Game.known_sentences:
		$Node2D/Translation.text = sentence["en"]
	else:
		$Node2D/Translation.text = "Unknown meaning"
	for word_id in sentence["word_ids"]:
		var word = Game.words[str(word_id)]
		var is_main_word = word_id == main_word_id
		words.append(word)
		var word_instance = load("res://Test/WordInSentenceCarousel.tscn").instance()
		
		word_instance.position.x = current_x
		word_instance.init(word_id, is_main_word)
		current_x += word_instance.width
		add_child(word_instance)
		children.append(word_instance)
	
	# Let's center everything
	var center_x = current_x / 2
	for word in children:
		word.position.x -= center_x
	$Node2D.position.x = -$Node2D/Translation.get_minimum_size()[0] / 2
