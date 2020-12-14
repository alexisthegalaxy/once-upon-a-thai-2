extends CanvasLayer

var number_of_rain_drops = 0
var drop = load("res://Effects/Raindrop.tscn")
const MAX_DROPS = 150
var x = 0

func _init():
	x = 2 * randf() - 1

func _process(delta):
	while number_of_rain_drops < MAX_DROPS:
		var new_drop = drop.instance()
		new_drop.init_rain_drop(x)
		new_drop.position.x = randi() % 320
		new_drop.position.y = -180 + randi() % 180
		self.add_child(new_drop)
		number_of_rain_drops += 1
