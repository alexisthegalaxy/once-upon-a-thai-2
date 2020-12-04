extends CanvasLayer

const NUMBER_OF_WORDS_PER_SIDE = 5
var NUMBER_OF_WORDS_TO_REVIEW = 15
var EasyLearnButton = load("res://Test/JobTest/EasyLearn/EasyLearnButton.tscn")
var tl_buttons = []
var sl_buttons = []
# The following five lists are lists of only IDs.
var all_words_to_review = []
var current_sl_words = []  # is always of size NUMBER_OF_WORDS_PER_SIDE
var current_tl_words = []  # is always of size NUMBER_OF_WORDS_PER_SIDE
var remaining_sl_words = []  # starts at NUMBER_OF_WORDS_TO_REVIEW - NUMBER_OF_WORDS_PER_SIDE, ends at 0 
var remaining_tl_words = []

var pressed_tl_word_id = null
var pressed_sl_word_id = null

var free_index_tl = null
var free_index_sl = null

const INITIAL_X_SL = 21
const INITIAL_X_TL = 184
const INITIAL_Y = 13
const DELTA_Y = 32

func set_number_of_words_to_review():
	if NUMBER_OF_WORDS_TO_REVIEW > len(Game.known_words):
		if len(Game.known_words) < 5:
			queue_free()
		else:
			NUMBER_OF_WORDS_TO_REVIEW = len(Game.known_words)

func init_words():
	var all_words_to_review = DistractorsHelper.get_words_to_review(NUMBER_OF_WORDS_TO_REVIEW)
	var initial_tl_words = [all_words_to_review[0], all_words_to_review[1]]
	var initial_sl_words = [all_words_to_review[0], all_words_to_review[1]]
	while len(initial_tl_words) < NUMBER_OF_WORDS_PER_SIDE:
		var random_word_id = all_words_to_review[randi() % len(all_words_to_review)]
		if not random_word_id in initial_tl_words:
			initial_tl_words.append(random_word_id)
	while len(initial_sl_words) < NUMBER_OF_WORDS_PER_SIDE:
		var random_word_id = all_words_to_review[randi() % len(all_words_to_review)]
		if not random_word_id in initial_sl_words:
			initial_sl_words.append(random_word_id)
	initial_sl_words.shuffle()
	initial_tl_words.shuffle()
	current_sl_words = initial_sl_words
	current_tl_words = initial_tl_words
	for word in all_words_to_review:
		if not word in initial_tl_words:
			remaining_tl_words.append(word)
		if not word in initial_sl_words:
			remaining_sl_words.append(word)

func _ready():
	set_number_of_words_to_review()
	init_words()
	var index = 0
	for sl_word_id in current_sl_words:
		var sl_button = EasyLearnButton.instance()
		sl_button.init_easy_learn_button(sl_word_id, "source", index)
		sl_button.position = get_button_position(sl_button)
		sl_buttons.append(sl_button)
		connect_button_signals(sl_button)
		self.add_child(sl_button)
		index += 1
	index = 0
	for tl_word_id in current_tl_words:
		var tl_button = EasyLearnButton.instance()
		tl_button.init_easy_learn_button(tl_word_id, "target", index)
		tl_button.position = get_button_position(tl_button)
		tl_buttons.append(tl_button)
		connect_button_signals(tl_button)
		self.add_child(tl_button)
		index += 1

func get_button_position(button):
	var x
	var y = INITIAL_Y + button.index * DELTA_Y
	if button.category == "source":
		x = INITIAL_X_SL
	else:
		x = INITIAL_X_TL
	return Vector2(x, y)

func _on_Button11_pressed():
	queue_free()
	Game.is_frozen = false

func press_button(word_id, category):
	var buttons_to_consider = null
	if category == "target":
		pressed_tl_word_id = word_id
		buttons_to_consider = tl_buttons
	else:
		pressed_sl_word_id = word_id
		buttons_to_consider = sl_buttons

	for button in buttons_to_consider:
		if not button.word.id == word_id:
			button.unpress()
	if pressed_tl_word_id and pressed_sl_word_id:
		if pressed_tl_word_id == pressed_sl_word_id:
			remove_buttons()
			add_buttons()
			add_floaty("up", "+10", Color(0, 1, 0, 1))
			SoundPlayer.play_sound("res://Sounds/money.wav")
		else:
			add_floaty("down", "-10", Color(1, 0, 0, 1))
			SoundPlayer.play_sound("res://Sounds/incorrect.wav")
			unpress_all_buttons()

func add_floaty(direction, _text, color):
	var floaty = load("res://UI/Floaty.tscn").instance()
	floaty.text = _text
	floaty.set_direction(direction)
	floaty.set_color(color.r, color.g, color.b)
	floaty.position.x = 5
	floaty.position.y = 5
	self.add_child(floaty)

func unpress_button(word_id, category):
	var buttons_to_consider = null
	if category == "target":
		pressed_tl_word_id = null
		buttons_to_consider = tl_buttons
	else:
		pressed_sl_word_id = null
		buttons_to_consider = sl_buttons
	
	for button in buttons_to_consider:
		button.unpress()

func unpress_all_buttons():
	for button in tl_buttons + sl_buttons:
		button.unpress()
	pressed_sl_word_id = null
	pressed_tl_word_id = null

func remove_buttons():
	for button in sl_buttons:
		if button.word.id == pressed_sl_word_id:
			free_index_sl = button.index
			sl_buttons.erase(button)
			pressed_sl_word_id = null
			button.queue_free()
	for button in tl_buttons:
		if button.word.id == pressed_tl_word_id:
			free_index_tl = button.index
			tl_buttons.erase(button)
			pressed_tl_word_id = null
			button.queue_free()
	if not tl_buttons:
		$AllDone.show()
		

func select_new_tl_word_to_add():
	var potential_new_tl_words_to_add = []
	for sl_button in sl_buttons:
		if sl_button.word.id in remaining_tl_words:
			potential_new_tl_words_to_add.append(sl_button.word.id)
	return potential_new_tl_words_to_add[randi() % len(potential_new_tl_words_to_add)]

func select_new_sl_word_to_add():
	return remaining_sl_words[randi() % len(remaining_sl_words)]

func connect_button_signals(button):
	var _e = button.connect("button_pressed", self, "press_button")
	_e = button.connect("button_unpressed", self, "unpress_button")

func add_buttons():
	if not remaining_tl_words:
		return
	# Add SL button
	var sl_button = EasyLearnButton.instance()
	var sl_new_word = select_new_sl_word_to_add()
	remaining_sl_words.erase(sl_new_word)
	sl_button.init_easy_learn_button(sl_new_word, "source", free_index_sl)
	sl_button.position = get_button_position(sl_button)
	sl_buttons.append(sl_button)
	free_index_sl = null
	connect_button_signals(sl_button)
	self.add_child(sl_button)
	# Add TL button
	var tl_button = EasyLearnButton.instance()
	var tl_new_word = select_new_tl_word_to_add()
	remaining_tl_words.erase(tl_new_word)
	tl_button.init_easy_learn_button(tl_new_word, "target", free_index_tl)
	tl_button.position = get_button_position(tl_button)
	tl_buttons.append(tl_button)
	free_index_tl = null
	connect_button_signals(tl_button)
	self.add_child(tl_button)

func _on_Button12_pressed():
	queue_free()
	Game.is_frozen = false
