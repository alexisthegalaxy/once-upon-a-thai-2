extends Node2D

var initial_x
var final_x
var moves_left = false
var moves_right = false
var type = ""

func _ready():
	initial_x = position.x
	final_x = position.x - 45

func _init_main_ui_button(_type):
	type = _type
	if type == "_see_letters":
		modulate = Color(0.45, 0.1, 0.88, 1)
	elif type == "_see_words":
		modulate = Color(0.75, 0.2, 0.1, 1)
	elif type == "_see_sentences":
		modulate = Color(0.15, 0.82, 0.21, 1)
	$Button.text = "   " + tr(_type)

func _process(delta):
	if moves_left:
		position.x = int((position.x + final_x) / (2))
		if position.x == final_x:
			moves_left = false
	if moves_right:
		position.x = int((position.x + initial_x) / (2))
		if position.x == initial_x:
			moves_right = false

func _on_Button_mouse_entered():
	moves_left = true
	moves_right = false

func _on_Button_mouse_exited():
	moves_right = true
	moves_left = false

func _on_Button_pressed():
	if type == "_go_to_letter_world":
		go_to_letter_world()

func go_to_letter_world():
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
