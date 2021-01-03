extends Node

var is_blackening = false
var alpha = 0

func _ready():
	pass

func _process(delta):
	if is_blackening:
		alpha += delta
		$CanvasLayer/BlackFadeOut.modulate = Color(1, 1, 1, alpha)

func handle_dialog_option(dialog_node, answer_index, npc):
	return
