extends YSort

export var on_water = true;
var is_under = false
var is_over = false

func _ready():
	if on_water:
		$SmallBridgeWaterReflections.visible = true
	else:
		$SmallBridgeWaterReflections.visible = false

func _on_Area2D2_body_entered(body):
	if not body == Game.player:
		return
	if is_under:
		return
	if not is_over:
		is_over = true
		if on_water:
			Game.current_scene.get_node("WaterTileMap").set_collision_layer_bit(0, false)
		else:
			for cliff in get_tree().get_nodes_in_group("Cliff"):
				cliff.set_collision_layer_bit(0, false)

func _on_Area2D2_body_exited(body):
	if not body == Game.player:
		return
	if is_under:
		return
	if is_over:
		is_over = false
		if on_water:
			Game.current_scene.get_node("WaterTileMap").set_collision_layer_bit(0, true)
		else:
			for cliff in get_tree().get_nodes_in_group("Cliff"):
				cliff.set_collision_layer_bit(0, true)

func _on_ComeUnderTheBridge_body_entered(body):
	if not body == Game.player:
		return
	if is_over:
		return
	if not is_under:
		is_under = true
		$Area2D.set_collision_layer_bit(0, false)
		self.sort_enabled = false
		ChangeMap.change_height(-30)

func _on_LeaveUnderTheBridge_body_entered(body):
	if not body == Game.player:
		return
	if is_over:
		return
	if is_under:
		is_under = false
		$Area2D.set_collision_layer_bit(0, true)
		self.sort_enabled = true
		ChangeMap.change_height(30)
