extends CanvasLayer

var rng = RandomNumberGenerator.new()
var word_ids
var over_word
var docks = []
var selected_dock_index = null
var selected_purifying_test_letter = null

var PurifyingTestLetter = load("res://Test/Purifying/PurifyingTestLetter.tscn")

func init_docks():
	docks = [$PurifyingWordDock1, $PurifyingWordDock2, $PurifyingWordDock3, $PurifyingWordDock4, $PurifyingWordDock5]
	var i = 0
	for word_id in word_ids:
		docks[i].init_purifying_dock(word_id, i)
		docks[i].connect("dock_is_selected", self, "selects_dock")
		docks[i].connect("erase_letters", self, "dock_erase_letters")
		i += 1

func dock_erase_letters(dock_index, erased_letter_ids):
	for letter_id in erased_letter_ids:
		add_letter(letter_id)

func selects_dock(dock_index):
	selected_dock_index = dock_index
	for dock in docks:
		if dock.index != dock_index:
			dock.unselect_dock()

func selects_letter(_selected_purifying_test_letter):
	print("selects_letter", selected_dock_index)
	selected_purifying_test_letter = _selected_purifying_test_letter
	if selected_dock_index == null:
		return
	else:
		docks[selected_dock_index].add_letter(selected_purifying_test_letter.letter_id)
		_selected_purifying_test_letter.queue_free()

func init(_word_ids, _over_word):
	Game.is_frozen = true
	Game.active_test = self
	over_word = _over_word
	word_ids = _word_ids
	rng.randomize()
	init_docks()
#	SoundPlayer.play_thai(word.th)
	if len(word_ids) == 4:
		$PurifyingWordDock5.hide()
	init_letters()
	
func init_letters():
	var letter_ids = []
	for word_id in word_ids:
		letter_ids += Game.words[str(word_id)].letters
	for letter_id in letter_ids:
		add_letter(letter_id)

func add_letter(letter_id):
	var purifying_test_letter = PurifyingTestLetter.instance()
	purifying_test_letter.init_purifying_test_letter(letter_id)
	purifying_test_letter.connect("purifying_letter_is_selected", self, "selects_letter")
	self.add_child(purifying_test_letter)

func answered_correctly():
	Game.active_test = null
	
	Game.player.can_interact = true
	Game.is_frozen = false
#	if not word.id in Game.known_words:
#		Game.known_words.append(word.id)
	over_word.queue_free()
	queue_free()

func _on_Button_pressed():
	$SentenceCarousel.show()
