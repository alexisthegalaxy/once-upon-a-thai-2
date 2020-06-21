extends Node2D

var time = 0

func _process(delta):
	$positive.rotation += delta / 2.1
	time += delta
	var positive_ratio = 1 + 0.2 * cos(time)
	$positive.scale.x = positive_ratio
	$positive.scale.y = positive_ratio
	
	$negative.rotation -= delta / 2.1
	time += delta
	var negative_ratio = 1 + 0.2 * sin(time)
	$negative.scale.x = negative_ratio
	$negative.scale.y = negative_ratio
