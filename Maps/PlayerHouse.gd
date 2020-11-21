extends Node

func _ready():
#	SoundPlayer.play_thai("ตุ๊กแก")
#	yield(get_tree().create_timer(1.0), "timeout")
	if Events.events["talked_to_nim_at_the_beginning"]:
		$YSort/Nim.dialog = [
			"_granny_is_waiting_outside",
			"_be_brave_okay"
		]
		$YSort/Nim.position = Vector2(72, -137)

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
		Game.space_bar_to_interact.get_node("Node2D").get_node("Label").text = tr("_move_with_arrow_keys")
#		get_tree().current_scene.add_child(Game.space_bar_to_interact)
		self.add_child(Game.space_bar_to_interact)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.space_bar_to_interact.queue_free()
		Game.space_bar_to_interact = null
