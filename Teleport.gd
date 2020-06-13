extends Area2D

export(String) var to_map_name
export(int) var to_x
export(int) var to_y


signal teleport_signal

func _ready():
	var _e = self.connect("teleport_signal", Game, "_on_teleport_signal")

func _on_Teleport_body_entered(_body):
	if _body.get_name() == "Player":
		print('teleport detects that Player enters and will go to ', to_map_name, ", ", to_x, ", ", to_y)
		emit_signal("teleport_signal", to_map_name, to_x, to_y)
