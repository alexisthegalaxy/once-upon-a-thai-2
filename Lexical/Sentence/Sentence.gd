extends StaticBody2D

export var id = 0
signal sentence_area_entered

func _ready():
	var _e = self.connect("sentence_area_entered", Game, "_on_sentence_area_entered", [])


func _on_Area2D_body_entered(_body):
	if _body == Game.player:
		emit_signal('sentence_area_entered', id, position.x, position.y)
