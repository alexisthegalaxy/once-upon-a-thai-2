extends Node2D

var word_1  # Spell instance
var word_2  # Spell instance

func _ready():
	appear()
	$Line2D.modulate = Color(1, 1, 1, 0)
	$Bolt.modulate = Color(1, 1, 1, 0)

func _init_word_net_link(point_1, point_2):
	$Line2D.points = [point_1, point_2]
	$Bolt.points = [point_1, point_2]

func becomes_transparent():
	$VisibilityTween.stop_all()
	$VisibilityTween.interpolate_property($Line2D, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2)
	$VisibilityTween.interpolate_property($Bolt, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 3)
	$VisibilityTween.start()

func becomes_opaque():
	$VisibilityTween.stop_all()
	$VisibilityTween.interpolate_property($Line2D, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5)
	$VisibilityTween.interpolate_property($Bolt, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.5)
	$VisibilityTween.start()

func appear() -> void:
	$SizeTween.stop_all()
	$SizeTween.interpolate_property($Line2D, "width", 0, 4.0, 3)
	$SizeTween.interpolate_property($Bolt, "width", 0, 4.0, 3)
	$SizeTween.start()
	
func disappear() -> void:
	$SizeTween.stop_all()
	$SizeTween.interpolate_property($Line2D, "width", 4.0, 0, 2)
	$SizeTween.interpolate_property($Bolt, "width", 4.0, 0, 2)
	$SizeTween.start()

func delete():
	disappear()
	var timer = Timer.new()
	timer.connect("timeout", self, "free")
	timer.set_wait_time(4)
	timer.set_one_shot(true)
	timer.autostart = true
	timer.start()
	add_child(timer)

func free():
	queue_free()
