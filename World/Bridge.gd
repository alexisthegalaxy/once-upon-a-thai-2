extends YSort

export var on_water = true;

#func _ready():
#	if on_water:
#		$Bridge.spri

func _on_Area2D2_body_entered(body):
	if not body == Game.player:
		return
	Game.current_scene.get_node("WaterTileMap").set_collision_layer_bit(0, false)

func _on_Area2D2_body_exited(body):
	if not body == Game.player:
		return
	Game.current_scene.get_node("WaterTileMap").set_collision_layer_bit(0, true)
