extends StaticBody2D


export(Array) var dialog = []

signal npc_body_entered
signal npc_body_exited


func _ready():
	var _e = self.connect("npc_body_entered", Game, "_on_InteractBox_body_entered", [self])
	var _f = self.connect("npc_body_exited", Game, "_on_InteractBox_body_exited", [self])

func _on_InteractBox_area_entered(body) -> void:
	print(body.get_parent().get_name())
	var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
	ui_dialog.dialog = dialog
	var current_map = get_tree().current_scene
	current_map.add_child(ui_dialog)


func initiate_dialog(player):
	var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
	ui_dialog.dialog = dialog
	var current_map = get_tree().current_scene
	current_map.add_child(ui_dialog)
	player.animationState.travel("Idle")
	player.velocity = Vector2.ZERO
	ui_dialog.player = player
	ui_dialog.reset_line()
	print('reset_line from npc initiate dialog')

func _on_InteractBox_body_entered(body):
	emit_signal('npc_body_entered', body)


func _on_InteractBox_body_exited(body):
	emit_signal('npc_body_exited', body)
