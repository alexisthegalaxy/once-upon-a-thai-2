extends Node2D

var initial_x
var final_x
var moves_left = false
var moves_right = false
var type = ""
signal is_pressed
signal is_hovered
signal is_not_hovered

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
	elif type == "_save_the_game":
		modulate = Color(0.8, 0.8, 0.8, 1)
	elif type == "_use_spell":
		modulate = Color(0.4, 0.6, 0.2, 1)
	elif type == "_make_spell":
		modulate = Color(0.8, 0.4, 0.8, 1)
	elif type == "_map":
		modulate = Color(0.8, 0.8, 0.2, 1)
	$Label.text = tr(_type)
	update_final_x()

func update_final_x():
	final_x = initial_x - max($Label.get_combined_minimum_size().x - 15, 35)

func _process(_delta):
	if moves_left:
		position.x = int((position.x + final_x) / 2)
		if position.x == final_x:
			moves_left = false
	if moves_right:
		position.x = int((position.x + initial_x) / 2)
		if position.x == initial_x:
			moves_right = false

func _on_Button_mouse_entered():
	emit_signal("is_hovered", type)
	moves_left = true
	moves_right = false

func _on_Button_mouse_exited():
	emit_signal("is_not_hovered", type)
	moves_right = true
	moves_left = false

func _on_Button_pressed():
	$Button.release_focus()
	emit_signal("is_pressed", type)
