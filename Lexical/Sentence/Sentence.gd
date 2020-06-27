extends StaticBody2D

export var id = 0
export var is_translated = false
signal sentence_area_entered

func interact(player):
	player.stop_walking()
	Game.discovers_sentence(id, is_translated)

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)
#		emit_signal('sentence_area_entered', id, position.x, position.y)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.loses_focus(self)
