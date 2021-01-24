extends CanvasLayer
# Test 5 of a Spell Encounter
var word
var word_id
var alpha = 0
var distractors = []  # a list of words
var over_word
var lo = TranslationServer.get_locale()

func set_alpha():
	$Explanation.modulate = Color(1, 1, 1, alpha)
	$Sprite.modulate = Color(1, 1, 1, alpha)

func init(_word_id, _over_word):
	word_id = _word_id
	Game.is_frozen = true
	over_word = _over_word
	word = Game.words[str(word_id)]
#	init_learn_letter_button()
	$English.text = word[lo]
	$Answer.text = ""
	$Keyboard.init_keyboard(false)
	$Keyboard.connect("text_change", self, "on_text_change")
	$Keyboard.connect("enter_pressed", self, "on_enter_pressed")

func on_text_change(text):
	$Answer.text = text

func on_enter_pressed():
	validate()

func _ready():
	set_alpha()

func _process(delta):
	if alpha < 1:
		alpha += delta * 2
		set_alpha()
	elif alpha > 1:
		alpha = 1
		set_alpha()

func answered_correctly():
#	Game.active_test = null
	SoundPlayer.play_thai(word.th)
	Game.player.can_interact = true
	Game.is_frozen = false
	Game.learn_word(word.id)
	Game.add_following_spell(word.id, over_word)
	SoundPlayer.play_sound("res://Sounds/ding.wav", 0)
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	var lines = [tr("_you_have_befriended_that_spell") % word.th]
	if len(Game.known_words) == 1:
		lines.append(tr("_press_f_to_open_your_dictionary_and_see_that_word"))
	Game.current_dialog.init_dialog(lines, null, null, null, null)
	Game.current_scene.add_child(Game.current_dialog)
	
	queue_free()
	Game.should_start_test_when_back_from_MP = [null, null]

func answered_wrongly():
	SoundPlayer.play_sound("res://Sounds/incorrect.wav", 0)

func _on_OK_pressed():
	validate()

func validate():
	if $Answer.text == word.th:
		answered_correctly()
	else:
		answered_wrongly()

func _on_Hint_mouse_entered():
	SoundPlayer.play_thai(word.th)
	$Hint.text = word.th

func _on_Hint_mouse_exited():
	SoundPlayer.play_thai(word.th)
	$Hint.text = tr("_hint")