extends Node2D

export(Array, String) var dialog = [tr("_there_is_a_mat_on_the_floor"), tr("_do_you_want_to_sleep_free")]
#export var sprite_path = "res://World/assets/IndoorBuddhaShrine.png"

func _ready():
	pass

func interact():
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog, self, null, false, null)
	Game.current_scene.add_child(Game.current_dialog)

func _on_InterractZone_body_entered(body):
	if not body == Game.player:
		return
	Game.gains_focus(self)

func _on_InterractZone_body_exited(body):
	if not body == Game.player:
		return
	Game.lose_focus(self)

func dialog_option(_dialog, answer_index):
	if answer_index == 1:  # yes, sleep here
		Game.player.sleep()
