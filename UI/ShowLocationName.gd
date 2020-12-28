extends CanvasLayer

var is_moving = false

func _ready():
	$Node2D/Label.text = tr(Game.current_location_name).replace("[Name]", Game.player_name)

func _process(delta):
	if not is_moving:
		return
	$Node2D.position.y -= delta * 100

func _on_StartMoving_timeout():
	is_moving = true

func _on_Delete_timeout():
	queue_free()
