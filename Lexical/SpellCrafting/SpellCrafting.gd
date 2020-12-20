extends CanvasLayer

var word_id

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.hide()
	$Keyboard.init_keyboard(true)
	$Keyboard.connect("text_change", self, "on_text_change")

func on_text_change(text):
	$TextEdit.text = text
	show_button_if_text_is_a_word(text)

func show_button_if_text_is_a_word(text):
	for _word_id in Game.words:
		if Game.words[_word_id].th == text:
			word_id = _word_id
			$Button.show()
			return
	$Button.hide()

func _on_Button_pressed():
	queue_free()
	Game.spell_crafting_screen = null
	var new_word = load("res://Lexical/Word/Spell.tscn").instance()
	new_word.id = int(word_id)
	new_word.word = Game.words[word_id]
	new_word.can_move = false
	new_word.position = Game.player.position
	call_deferred("add_word", new_word)
	remove_letters_from_bag(Game.words[word_id].th)

func add_word(new_word):
	Game.current_scene.get_node("YSort").add_child(new_word)

func remove_letters_from_bag(thai_word):
	for letter in thai_word:
		Game.letters[get_letter_id_from_thai(letter)].in_bag -= 1

func get_letter_id_from_thai(thai):
	for letter_id in Game.letters:
		if Game.letters[letter_id].th in [thai, '-' + thai]:
			return letter_id
