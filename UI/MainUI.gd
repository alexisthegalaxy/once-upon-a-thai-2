extends CanvasLayer


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
	update_main_ui_money_display()
	update_main_ui_letters_display()
	update_main_ui_words_display()
	update_main_ui_sentences_display()
	update_main_ui_go_letter_world_display()
	update_main_ui_use_spell_display()
	update_main_ui_make_spell_display()
	update_main_ui_quests_display()

func update_main_ui_letters_display():
	if Game.known_letters:
		$Letters.show()
	else:
		$Letters.hide()

func update_main_ui_words_display():
	if Game.known_words:
		$Words.show()
	else:
		$Words.hide()

func update_main_ui_sentences_display():
	if Game.known_sentences:
		$Sentences.show()
	else:
		$Sentences.hide()

func update_main_ui_money_display():
	if Events.events.money_is_visible:
		$Money.show()
		$Money/Label.text = "฿" + str(Game.money)
	else:
		$Money.hide()

func update_main_ui_go_letter_world_display():
	if Events.events.has_finished_the_letter_world_the_first_time:
		$GoLetterWorld.show()
		if Game.is_in_letter_world():
			$GoLetterWorld/Label.text = tr("_go_back_to_the_material_world")
		else:
			$GoLetterWorld/Label.text = tr("_go_to_letter_world")
		$GoLetterWorld.update_final_x()
	else:
		$GoLetterWorld.hide()

func update_main_ui_use_spell_display():
	if Game.following_spells:
		$UseSpell.show()
	else:
		$UseSpell.hide()

func update_main_ui_make_spell_display():
	if Events.events.has_possessed_a_letter and Quests.quests.find_sentences_in_chaiyaphum.status == Quests.DONE:
		$MakeSpell.show()
	else:
		$MakeSpell.hide()

func update_main_ui_quests_display():
	if Events.events.has_had_a_quest or Quests.has_quests_in_progress_or_finished():
		$Quests.show()
		update_quests_display()
	else:
		$Quests.hide()

func update_quests_display():
	var quest_button_text = $QuestsDisplay.update_quests_display()
	if quest_button_text:
		$Quests/Label.text = quest_button_text

func open_quest_display():
	$QuestsDisplay.open_quest_display()

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
		display_use_spell()
	elif type == "_make_spell":
		display_spell_crafting()
	elif type == "_save_the_game":
		Save.save_game()

func display_use_spell():
	Game.select_follower_to_implant_screen = load("res://Lexical/Source/SelectFollowerToImplant.tscn").instance()
	Game.select_follower_to_implant_screen.init_select_follower_to_implant_screen(null)
	Game.current_scene.add_child(Game.select_follower_to_implant_screen)
	
func display_words():
	var dict = load("res://Lexical/Dict/Dict.tscn").instance()
	Game.dict = dict
	dict.init_dict()
	Game.current_scene.add_child(dict)

func display_alphabet():
	var alphabet = load("res://Lexical/Alphabet/Alphabet.tscn").instance()
	Game.alphabet = alphabet
	alphabet.init_alphabet()
	Game.current_scene.add_child(alphabet)

func display_spell_crafting():
	var spell_crafting_scene = load("res://Lexical/SpellCrafting/SpellCrafting.tscn").instance()
	Game.spell_crafting_screen = spell_crafting_scene
	Game.current_scene.add_child(spell_crafting_scene)

func display_notebook():
	var notebook = load("res://Lexical/Notebook/Notebook.tscn").instance()
	Game.notebook = notebook
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
	else:
		Game.call_deferred("_deferred_goto_scene", "res://Maps/LexicalWorld/LetterHub.tscn", -139, 75, 0)
