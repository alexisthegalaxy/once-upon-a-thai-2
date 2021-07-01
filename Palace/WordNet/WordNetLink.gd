extends Node2D

var word_1 = null
var word_2 = null

func _ready():
	appear()

func _init_word_net_link(point_1, point_2):
	$Line2D.points = [point_1, point_2]

func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 4.0, 4)
	$Tween.start()
	
func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 4.0, 0, 4)
	$Tween.start()
	
	
	
