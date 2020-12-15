extends Node2D

var answer_index
var dialog
var caller

func init_option(_dialog, _caller, _answer_index):
	answer_index = _answer_index
	dialog = _dialog
	caller = _caller

func set_selected(value):
	if value:
		$Button.grab_focus()
	else:
		$Button.release_focus()

func _on_Button_pressed():
	caller.dialog_option(dialog, answer_index)
	dialog.next_line()
