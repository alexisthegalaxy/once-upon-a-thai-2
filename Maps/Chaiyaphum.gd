extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D5_body_entered(body):
	# Blocker 1
	if body == Game.player:
		if not Events.events["talked_to_yaai_for_the_first_time"]:
			var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"[Name]: I should talk to my grandmother first..."
			]
			ui_dialog.init(dialog, self, null, false)
			Game.player.stop_walking()
			get_tree().current_scene.add_child(ui_dialog)
			Game.player.forced_toward(Vector2(553, 442))

func _on_Area2D_body_entered(body):
	# Blocker 2
	if body == Game.player:
		if not Events.events["ceremony_finished"]:
			var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"[Name]: I shouldn't go there now..."
			]
			ui_dialog.init(dialog, self, null, false)
			Game.player.stop_walking()
			get_tree().current_scene.add_child(ui_dialog)
			Game.player.forced_toward(Vector2(541, 240))

func _on_Area2D2_body_entered(body):
	if body == Game.player:
		if not Events.events["yaai_went_to_forest_entrance"]:
			Events.events["yaai_went_to_forest_entrance"] = true
			$YSort/NPCs/Yaai.will_go_to = [
				Vector2(430.30, 257.27),
				Vector2(388.46, 288.40),
				Vector2(330.59, 264.30),
				Vector2(275.59, 273.01),
				Vector2(207.96, 326.66),
				Vector2(171.95, 421.33),
				Vector2(128.83, 516.44),
				Vector2(207.81, 504.86),
				Vector2(207.81, 513.20),
			]
			$YSort/NPCs/Yaai.starts_going_toward($YSort/NPCs/Yaai.will_go_to[0])
