extends Area2D

export(Color) var color

signal changelight_signal

func _ready():
	var _e = self.connect("changelight_signal", Game, "_on_changelight_entered", [])

func _on_Teleport_body_entered(_body):
	if _body.get_name() == "Player":
		emit_signal("changelight_signal", color)
