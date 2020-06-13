extends Area2D

export(Color) var color


signal changelight_signal


func _on_Teleport_body_entered(_body):
	print('changelight_signal')
	emit_signal("changelight_signal", color)
