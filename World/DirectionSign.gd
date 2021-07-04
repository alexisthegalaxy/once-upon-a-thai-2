extends Node2D

export(String) var content = "ชัยภูมิ"
export(Array, String) var dialog = ["_this_road_leads_to_chaiyaphum"]
export var is_invisible = false

func _ready():
	if is_invisible:
		$Sprite.visible = false
		$StaticBody2D.set_collision_layer_bit(0, false)
	$Label.text = content

func interact():
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog, self, null, false, null)
	Game.current_scene.add_child(Game.current_dialog)

func _on_Area2D2_body_entered(body):
	if not body == Game.player:
		return
	Game.gains_focus(self)

func _on_Area2D2_body_exited(body):
	if not body == Game.player:
		return
	Game.lose_focus(self)
