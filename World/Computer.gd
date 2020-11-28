extends StaticBody2D

export(Array, String) var dialog = ["_this_is_a_shrine"]
export var sprite_path = "res://World/assets/IndoorBuddhaShrine.png"
export var is_on = false

func _ready():
	if is_on:
		$computer_on.show()
		$computer_off.hide()
	else:
		$computer_off.show()
		$computer_on.hide()

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
