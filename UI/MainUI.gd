extends CanvasLayer

var hovered_buttons = []

func _ready():
	$Letters._init_main_ui_button("_see_letters")
	$Words._init_main_ui_button("_see_words")
	$Sentences._init_main_ui_button("_see_sentences")
	$Quests._init_main_ui_button("_quests")
	$UseSpell._init_main_ui_button("_use_spell")
	$MakeSpell._init_main_ui_button("_make_spell")
	$Save._init_main_ui_button("_save_the_game")
	$Map._init_main_ui_button("_map")
	for button in [$Letters, $Words, $Sentences, $Quests, $UseSpell, $MakeSpell, $Save, $Map]:
		button.connect("is_pressed", self, "on_button_pressed")
		button.connect("is_hovered", self, "on_button_hovered")
		button.connect("is_not_hovered", self, "on_button_not_hovered")

func update_main_ui():
	update_main_ui_money_display()
	update_main_ui_letters_display()
	update_main_ui_words_display()
	update_main_ui_sentences_display()
	update_main_ui_use_spell_display()
	update_main_ui_make_spell_display()
	update_main_ui_quests_display()
	update_main_ui_map_display()

func update_main_ui_letters_display():
	if Game.known_letters or Game.should_show_letters_button:
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

func update_main_ui_use_spell_display():
	if Game.following_spells:
		$UseSpell.show()
	else:
		$UseSpell.hide()

func update_main_ui_make_spell_display():
	if Events.events.has_possessed_a_letter and "find_sentences_in_chaiyaphum" in Quests.quests and Quests.quests.find_sentences_in_chaiyaphum.status == Quests.DONE:
		$MakeSpell.show()
	else:
		$MakeSpell.hide()

func update_main_ui_quests_display():
	if Events.events.has_had_a_quest or Quests.has_quests_in_progress_or_finished():
		$Quests.show()
		update_quests_display()
	else:
		$Quests.hide()

func update_main_ui_map_display():
	if Events.events.has_the_map:
		$Map.show()
	else:
		$Map.hide()

func main_ui_process_click(_event) -> bool:
	var event_is_processed = false
	if Input.is_action_just_pressed("click"):
		if hovered_buttons or $QuestsDisplay.is_hovering_over_buttons():
			event_is_processed = true
	return event_is_processed

func update_quests_display():
	var quest_button_text = $QuestsDisplay.update_quests_display()
	if quest_button_text:
		$Quests/Label.text = quest_button_text

func open_quest_display():
	$QuestsDisplay.open_quest_display()

func close_quest_display():
	$QuestsDisplay.close_quest_display()

func on_button_pressed(type):
	if type == "_see_letters":
#		display_alphabet()
		display_akson()
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
	elif type == "_map":
		display_map()

func on_button_hovered(type):
	hovered_buttons.append(type)

func on_button_not_hovered(type):
	hovered_buttons.erase(type)

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

func display_akson():
	var akson = load("res://Lexical/Akson/Akson.tscn").instance()
	Game.akson = akson
	akson.init_akson([], true)
	Game.current_scene.add_child(akson)

func display_spell_crafting():
	var spell_crafting_scene = load("res://Lexical/SpellCrafting/SpellCrafting.tscn").instance()
	Game.spell_crafting_screen = spell_crafting_scene
	Game.current_scene.add_child(spell_crafting_scene)

func display_notebook():
	var notebook = load("res://Lexical/Notebook/Notebook.tscn").instance()
	Game.notebook = notebook
	Game.current_scene.add_child(notebook)
	notebook.init_notebook(0)

func display_map():
	if Game.map:
		Game.map.queue_free()
		Game.map = null
	else:
		var map = load("res://Map/Map.tscn").instance()
		Game.map = map
		Game.current_scene.add_child(map)
		map.init_map()
