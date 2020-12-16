extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Letters._init_main_ui_button("_see_letters")
	$Words._init_main_ui_button("_see_words")
	$Sentences._init_main_ui_button("_see_sentences")
	$GoLetterWorld._init_main_ui_button("_go_to_letter_world")
	$Quests._init_main_ui_button("_quests")
	$UseSpell._init_main_ui_button("_use_spell")
	$MakeSpell._init_main_ui_button("_make_spell")
	$Save._init_main_ui_button("_save_the_game")
	
	$Letters.connect("is_pressed", self, "on_button_pressed")
	$Words.connect("is_pressed", self, "on_button_pressed")
	$Sentences.connect("is_pressed", self, "on_button_pressed")
	$GoLetterWorld.connect("is_pressed", self, "on_button_pressed")
	$Quests.connect("is_pressed", self, "on_button_pressed")
	$UseSpell.connect("is_pressed", self, "on_button_pressed")
	$MakeSpell.connect("is_pressed", self, "on_button_pressed")
	$Save.connect("is_pressed", self, "on_button_pressed")

func update_main_ui():
	if Game.known_letters:
		$Letters.show()
	else:
		$Letters.hide()
	if Game.known_words:
		$Words.show()
	else:
		$Words.hide()
	if Game.known_sentences:
		$Sentences.show()
	else:
		$Sentences.hide()
	if Events.events.money_is_visible:
		$Money.show()
	else:
		$Money.hide()
	if Events.events.has_finished_the_letter_world_the_first_time:
		$GoLetterWorld.show()
		if Game.is_in_letter_world():
			$GoLetterWorld/Button.text = "   " + tr("_go_back_to_the_material_world")
		else:
			$GoLetterWorld/Button.text = "   " + tr("_go_to_letter_world")
	else:
		$GoLetterWorld.hide()
	if Game.following_spells:
		$UseSpell.show()
	else:
		$UseSpell.hide()
	if Events.events.has_possessed_a_letter:
		$MakeSpell.show()
	else:
		$MakeSpell.hide()
	if Events.events.has_had_a_quest:
		$Quests.show()
		update_quests_display()
	else:
		$Quests.hide()

func update_quests_display():
	var quest_button_text = $QuestsDisplay.update_quests_display()
	if quest_button_text:
		$Quests/Button.text = quest_button_text

func on_button_pressed(type):
	if type == "_go_to_letter_world":
		go_to_letter_world()
	elif type == "_see_letters":
		display_alphabet()
	elif type == "_see_words":
		display_words()
	elif type == "_see_sentences":
		display_notebook()
	elif type == "_quests":
		$QuestsDisplay._press_quests_button()
	elif type == "_use_spell":
		pass
	elif type == "_make_spell":
		pass
	elif type == "_save_the_game":
		Save.save_game()

func display_words():
	var dict = load("res://Lexical/Dict/Dict.tscn").instance()
	Game.player.dict = dict
	dict.init_dict()
	Game.current_scene.add_child(dict)

func display_alphabet():
	var alphabet = load("res://Lexical/Alphabet/Alphabet.tscn").instance()
	Game.player.alphabet = alphabet
	alphabet.init_alphabet()
	Game.current_scene.add_child(alphabet)

func display_notebook():
	var notebook = load("res://Lexical/Notebook/Notebook.tscn").instance()
	Game.player.notebook = notebook
	Game.current_scene.add_child(notebook)
	notebook.init_notebook(0)

func go_to_letter_world():
	if Game.is_in_letter_world():
		Game.letters_we_look_for = []
		Game.call_deferred(
			"_deferred_goto_scene",
			Game.player_last_overworld_map_visited,
			Game.player_position_on_overworld.x,
			Game.player_position_on_overworld.y,
			0
		)
	else:  # Going to the letter world
		Game.call_deferred("_deferred_goto_scene", "res://Maps/LexicalWorld/LetterHub.tscn", -139, 75, 0)
