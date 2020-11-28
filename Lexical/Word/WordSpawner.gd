extends Node2D

export var word_ids = [1]
export var max_number_of_words = 3
var current_words = []
var time = 0

func prune_removed_words():
	var new_current_words = []
	for current_word in current_words:
		# todo also check the following words I guess
		if is_instance_valid(current_word):
			new_current_words.append(current_word)
	current_words = new_current_words

func init_word_spawner(_word_ids, _max_number_of_words, _wait_time, spawn_immediately):
	$Sprite.hide()
	var _e = $Timer.connect("timeout", self, "timeout")
	$Timer.wait_time = _wait_time
	max_number_of_words = _max_number_of_words
	word_ids = _word_ids
	$Timer.start()
	if spawn_immediately:
		# We wait a bit so make sure the word has been updated after a scene change
		yield(get_tree().create_timer(0.1), "timeout")
		timeout()

func timeout():
	if not word_ids:
		return
	prune_removed_words()
#	if Game.player.position.distance_to(position) > 200:
#		return
	if Game.is_overworld_frozen():
		return
	if len(current_words) < max_number_of_words:
		var new_word = load("res://Lexical/Word/Spell.tscn").instance()
		var word_id = word_ids[randi() % word_ids.size()]
		new_word.id = word_id
		new_word.word = Game.words[str(word_id)]
		new_word.can_move = true
		new_word.position = get_global_position()
		current_words.append(new_word)
		call_deferred("add_word", new_word)

func add_word(new_word):
	Game.current_scene.get_node("YSort").add_child(new_word)
