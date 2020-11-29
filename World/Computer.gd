extends StaticBody2D

var dialog
export var sprite_path = "res://World/assets/IndoorBuddhaShrine.png"
export var is_on = false

func _ready():
	if is_on:
		$computer_on.show()
		$computer_off.hide()
		dialog = [tr("_it_looks_like_somebody_else_uses_this_computer")]
	else:
		$computer_off.show()
		$computer_on.hide()
		dialog = [tr("_name_turns_the_computer_on")]

func interact():
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog, self, ["starts_job_menu_screen", null], false, null)
#	Game.current_dialog.post_dialog = "starts_deducing_coop"
	Game.current_scene.add_child(Game.current_dialog)

func _on_InterractZone_body_entered(body):
	if not body == Game.player:
		return
	Game.gains_focus(self)

func _on_InterractZone_body_exited(body):
	if not body == Game.player:
		return
	Game.lose_focus(self)
