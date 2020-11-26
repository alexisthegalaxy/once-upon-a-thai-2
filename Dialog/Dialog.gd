extends CanvasLayer

export var dialog = []
var page = 0
var caller
var post_dialog_event
var post_dialog_signal
var current_line_has_question = false
var options = []
var current_answer_index = 1
var line_has_finished_writing = false
var test = "test test"
var time = 0
var this_line_doesnt_show_the_name = false
var display_name = ""
var can_skip = false

func _ready():
	reset_line()
	hide_answers()

func process(_dialog_line: String) -> String:
	var dialog_line = tr(_dialog_line)
	this_line_doesnt_show_the_name = false
	if "[ShowNoName]" in dialog_line:
		this_line_doesnt_show_the_name = true
		dialog_line = dialog_line.replace("[ShowNoName]", "")
		
	if this_line_doesnt_show_the_name:
		$Control/NameLabel.hide()
		$Control/NameTexture.hide()	
	elif display_name:
		$Control/NameLabel.show()
		$Control/NameTexture.show()	
	
	var processed_dialog = dialog_line.replace("[Name]", Game.player_name)
	if processed_dialog[0] == "-":
		processed_dialog = " " + processed_dialog
	if "[sound]" in processed_dialog:
		SoundPlayer.play_thai(caller.letter["audio"])
		processed_dialog = processed_dialog.replace("[sound]", "")
	elif "[sound:" in processed_dialog:
		var sound_to_play = processed_dialog.split("[sound:")[1].split("]")[0]
		processed_dialog = processed_dialog.replace("[sound:" + sound_to_play + "]", "")
		SoundPlayer.play_thai(sound_to_play)
	if current_line_has_question:
		processed_dialog = processed_dialog.split("@Q")[0]
	return processed_dialog

func reset_line():
	current_line_has_question = "@Q" in dialog[page]
	if current_line_has_question:
		options = dialog[page].split("@Q")[1].split("/")
		if len(options) >= 2:
			$Control/Options/Option1.get_node("Label").text = options[0]
			$Control/Options/Option2.get_node("Label").text = options[1]
		if len(options) >= 3:
			$Control/Options/Option3.get_node("Label").text = options[2]
		if len(options) >= 4:
			$Control/Options/Option4.get_node("Label").text = options[3]
	elif line_has_finished_writing:
		line_has_finished_writing = false
		hide_answers()
		$Control/NextPage.hide()
	var processed_dialog = process(dialog[page])
	$Control/RichTextLabel.set_bbcode(processed_dialog)
	$Control/RichTextLabel.set_visible_characters(0)

func init_dialog(_dialog, _caller, _post_dialog_event, _post_dialog_signal, speaker_name_if_no_caller):
	dialog = _dialog
	caller = _caller
	post_dialog_event = _post_dialog_event
	post_dialog_signal = _post_dialog_signal
	if speaker_name_if_no_caller:
		display_name = speaker_name_if_no_caller
	elif _caller and _caller.get("display_name"):
		display_name = _caller.display_name
	if display_name:
		$Control/NameLabel.set_bbcode("[center]" + tr(display_name) + "[/center]")
	else:
		$Control/NameLabel.hide()
		$Control/NameTexture.hide()
	
	$Control/Options/Option1.init_option(self, caller, 1)
	$Control/Options/Option2.init_option(self, caller, 2)
	$Control/Options/Option3.init_option(self, caller, 3)
	$Control/Options/Option4.init_option(self, caller, 4)

func dialog_ends():
	queue_free()
	Game.player.end_dialog()
	if caller and "is_talking" in caller:
		caller.is_talking = false
	if post_dialog_event:
		if typeof(post_dialog_event) == TYPE_STRING and post_dialog_event == "post_dialog":
			caller.post_dialog()
		else:
			Events.execute(post_dialog_event[0], post_dialog_event[1])
	if post_dialog_signal:
		caller.dialog_ended()
	if caller and caller.has_method("start_quest"):
		caller.start_quest()
		
	Game.reset_focus()
#	Game.loses_focus(Game.current_focus)

func next_line():
	page += 1
	if page >= dialog.size():
		dialog_ends()
	else:
		reset_line()

func _process(delta):
	if Input.is_action_just_pressed("interact"):
		get_tree().set_input_as_handled()
		if $Control/RichTextLabel.get_visible_characters() > $Control/RichTextLabel.get_total_character_count():
			if not current_line_has_question:
				next_line()
		elif can_skip:
			$Control/RichTextLabel.set_visible_characters($Control/RichTextLabel.get_total_character_count())
			line_has_finished_writing = true
			if current_line_has_question:
				reveal_answers()
	if line_has_finished_writing:
		time += delta
		$Control/NextPage.modulate = Color(1, 1, 1, cos(time * 10) / 2 + 0.5)

func _on_Timer_timeout():
	var number_of_characters_before = $Control/RichTextLabel.get_visible_characters()
	can_skip = number_of_characters_before > 3
	$Control/RichTextLabel.set_visible_characters(number_of_characters_before + 2)
	if number_of_characters_before + 2 >= len(dialog[page]):
		line_has_finished_writing = true
		if current_line_has_question:
			reveal_answers()
		else:
			$Control/NextPage.show()

func will_reveal_answers_in_one_half_second():
	var timer = Timer.new()
	timer.connect("timeout", self, "reveal_answers")
	timer.set_wait_time(0.5)
	timer.set_one_shot(true)
	timer.autostart = true
	timer.start()
	add_child(timer)

func hide_answers():
	$Control/Options/Option1.hide()
	$Control/Options/Option2.hide()
	$Control/Options/Option3.hide()
	$Control/Options/Option4.hide()

func reveal_answers():
	line_has_finished_writing = true
	$Control/Options/Option1.show()
	$Control/Options/Option2.show()
	if len(options) >= 3:
		$Control/Options/Option3.show()
	if len(options) >= 4:
		$Control/Options/Option4.show()
