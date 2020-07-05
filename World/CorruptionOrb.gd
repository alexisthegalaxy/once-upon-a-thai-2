extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(0, 0)
var is_disappearing = false
var is_being_born = true
var max_scale = Vector2(0.5, 0.5)

func _ready():
	scale = Vector2(0.01, 0.01)

func timeout():
	is_disappearing = true

func _process(delta):
	position = position + delta * velocity
	velocity.y += 0.05
	var _e = $Timer.connect("timeout", self, "timeout")

	if is_being_born:
		scale = (scale * 9 + max_scale * 1.1) / 10
		if scale.x > max_scale.x:
			is_being_born = false

	if is_disappearing:
		var ratio = scale.x - 3 * delta / 30
		scale.x = ratio
		scale.y = ratio
		if ratio <= 0:
			queue_free()

func starts_disappearing():
	is_disappearing = true
