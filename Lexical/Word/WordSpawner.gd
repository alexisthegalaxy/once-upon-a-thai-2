extends Node2D

export var word_id = 1
var current_words = []
var time = 0
export var max_number_of_words = 3

func prune_removed_words():
	var new_current_words = []
	for current_word in current_words:
		if is_instance_valid(current_word):
			new_current_words.append(current_word)
	current_words = new_current_words

func timeout():
	if Game.player.position.distance_to(position) > 200:
		return
	prune_removed_words()
	if len(current_words) < max_number_of_words:
		var new_word = load("res://Lexical/Word/Spell.tscn").instance()
		new_word.id = word_id
		new_word.word = Game.words[str(word_id)]
		new_word.can_move = true
		new_word.position = position
		current_words.append(new_word)
		call_deferred("add_word", new_word)

func add_word(new_word):
	get_tree().current_scene.get_node("YSort").add_child(new_word)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.hide()
	var _e = $Timer.connect("timeout", self, "timeout")
	timeout()

## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
#	var timer = Timer.new()
#	timer.connect("timeout", self, "play_audio")
#	timer.set_wait_time(1)
#	timer.set_one_shot(true)
#	timer.autostart = true
#	timer.start()
#	add_child(timer)
