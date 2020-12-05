extends Node2D

var original_x
var original_y
var time = 0
var circle_multiplier_x = 0
var circle_multiplier_y = 0
var speed_multiplier = 0
var alpha = 0
var text
var is_correct
var test
var has_been_answered_and_is_wrong = false

signal test_answered_correctly

func set_alpha():
	$Button.modulate = Color(1, 1, 1, alpha)

func init(_test, answer_string, _is_correct):
	test = _test
	var _e = self.connect("test_answered_correctly", test, "answered_correctly", [])
	text = answer_string
	is_correct = _is_correct
	$Button/Label.text = answer_string

func _ready():
	set_alpha()
	original_x = position.x
	original_y = position.y
	time += 4 * randf()
	circle_multiplier_x = 5 * randf() - 5 * randf()
	circle_multiplier_y = 5 * randf() - 5 * randf()
	speed_multiplier = 3 * randf() - 3 * randf()

func _process(delta):
	time += delta
	position.x = original_x + circle_multiplier_x * cos(time * speed_multiplier)
	position.y = original_y + circle_multiplier_y * sin(time * speed_multiplier)
	if alpha < 1:
		alpha += delta * 2
		set_alpha()

func _on_Button_pressed():
	if is_correct:
		SoundPlayer.play_sound("res://Sounds/ding.wav", 0)
		emit_signal("test_answered_correctly")
	else:
		SoundPlayer.play_sound("res://Sounds/incorrect.wav", 0)
		has_been_answered_and_is_wrong = true
		$Button.disabled = true
