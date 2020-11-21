extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(_player):
	player = _player
	if Events.events["has_finished_the_letter_world_the_first_time"]:
		$LetterWorld.show()
		if "LexicalWorld" in Game.current_map_name:
			$LetterWorld.text = tr("_go_back_to_the_material_world")
		else:
			$LetterWorld.text = tr("_go_to_the_letter_world")
	else:
		$LetterWorld.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func close_hub():
	player.hub.queue_free()
	player.hub = null
	

func _on_Words_pressed():
	var dict = load("res://Lexical/Dict/Dict.tscn").instance()
	player.dict = dict
	close_hub()
	dict.init()
	Game.current_scene.add_child(dict)


func _on_Letters_pressed():
	var alphabet = load("res://Lexical/Alphabet/Alphabet.tscn").instance()
	player.alphabet = alphabet
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
			Game.player_position_on_overworld.y
		)
	else:  # Going to the letter world
		Game.call_deferred("_deferred_goto_scene", "res://Maps/LexicalWorld/LetterHub.tscn", -139, 75)

func _on_Sentences_pressed():
	var notebook = load("res://Lexical/Notebook/Notebook.tscn").instance()
	player.notebook = notebook
	close_hub()
	Game.current_scene.add_child(notebook)
	notebook.init(0)
