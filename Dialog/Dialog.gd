extends CanvasLayer

export var dialog = []
var page = 0
var player
var caller
var post_dialog_event
var post_dialog_signal
var current_line_has_question = false
var current_answer_index = 1
var answers_are_revealed = false

func _ready():
	reset_line()
	$Control/Answers.hide()

func process(dialog_line: String) -> String:
	var processed_dialog = dialog_line.replace("[Name]", Game.player_name)
	if processed_dialog[0] == "-":
		processed_dialog = " " + processed_dialog
	if current_line_has_question:
		processed_dialog = processed_dialog.split("@Q")[0]
	return processed_dialog

func reset_line():
	answers_are_revealed = false
	current_line_has_question = "@Q" in dialog[page]
	if current_line_has_question:
		var options = dialog[page].split("@Q")[1].split("/")
		$Control/Answers/Answer1.text = options[0]
		$Control/Answers/Answer2.text = options[1]
	var processed_dialog = process(dialog[page])
	$Control/RichTextLabel.set_bbcode(processed_dialog)
	$Control/RichTextLabel.set_visible_characters(0)

func init(_dialog, _player, _caller, _post_dialog_event, _post_dialog_signal):
	dialog = _dialog
	player = _player
	caller = _caller
	post_dialog_event = _post_dialog_event
	post_dialog_signal = _post_dialog_signal

func dialog_ends():
	queue_free()
	player.end_dialog()
	if post_dialog_event:
		Events.execute(post_dialog_event[0], post_dialog_event[1])
	if post_dialog_signal:
		caller.dialog_ended()
#	Game.loses_focus(Game.current_focus)

func next_line():
	page += 1
	if page >= dialog.size():
		dialog_ends()
	else:
		reset_line()

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if $Control/RichTextLabel.get_visible_characters() > $Control/RichTextLabel.get_total_character_count():
			if current_line_has_question:
				if current_answer_index == 1:
					caller.dialog_option(1)
				if current_answer_index == 2:
					caller.dialog_option(2)
			next_line()

func _on_Timer_timeout():
	var number_of_characters_before = $Control/RichTextLabel.get_visible_characters()
	$Control/RichTextLabel.set_visible_characters(number_of_characters_before + 2)
	if current_line_has_question && number_of_characters_before + 2 >= len(dialog[page]):
		if not answers_are_revealed:
			answers_are_revealed = true
			$Control/Answers.show()
			$Control/Answers/SpriteAnswer2.hide()

func _input(_event) -> void:
	if Input.is_action_just_pressed("ui_up"):
		current_answer_index = 1
		reset_answer_index()
	if Input.is_action_just_pressed("ui_down"):
		current_answer_index = 2
		reset_answer_index()

func reset_answer_index():
	if current_answer_index == 1:
		$Control/Answers/SpriteAnswer1.show()
		$Control/Answers/SpriteAnswer2.hide()
	elif current_answer_index == 2:
		$Control/Answers/SpriteAnswer2.show()
		$Control/Answers/SpriteAnswer1.hide()

func _on_Answer1InteractArea_mouse_entered():
	current_answer_index = 1
	reset_answer_index()

func _on_Answer2InteractArea_mouse_entered():
	current_answer_index = 2
	reset_answer_index()

func _on_Answer1InteractArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		current_answer_index = 1
		next_line()
		caller.dialog_option(1)

func _on_Answer2InteractArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		current_answer_index = 2
		next_line()
		caller.dialog_option(2)
