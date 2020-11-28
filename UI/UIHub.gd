extends CanvasLayer

func _ready():
	if Events.events["has_finished_the_letter_world_the_first_time"]:
		$LetterWorld.show()
		if "LexicalWorld" in Game.current_map_name:
			$LetterWorld.text = tr("_go_back_to_the_material_world")
		else:
			$LetterWorld.text = tr("_go_to_the_letter_world")
	else:
		$LetterWorld.hide()

func close_hub():
	Game.player.hub.queue_free()
	Game.player.hub = null
	

func _on_Words_pressed():
	var dict = load("res://Lexical/Dict/Dict.tscn").instance()
	Game.player.dict = dict
	close_hub()
	dict.init()
	Game.current_scene.add_child(dict)

func _on_Letters_pressed():
	var alphabet = load("res://Lexical/Alphabet/Alphabet.tscn").instance()
	Game.player.alphabet = alphabet
	close_hub()
	alphabet.init()
	Game.current_scene.add_child(alphabet)

func _on_LetterWorld_pressed():
	# Going to the material world
	if "LexicalWorld" in Game.current_map_name:
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

func _on_Sentences_pressed():
	var notebook = load("res://Lexical/Notebook/Notebook.tscn").instance()
	Game.player.notebook = notebook
	close_hub()
	Game.current_scene.add_child(notebook)
	notebook.init(0)
