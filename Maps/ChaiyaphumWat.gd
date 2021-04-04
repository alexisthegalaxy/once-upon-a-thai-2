extends Node
var province = "chaiyaphum"

func _ready():
	if (len(Game.seen_sentences) + len(Game.known_sentences) > 5):
		# Then Ploy will be doing research
		$YSort/NPCs/Ploy.queue_free()
	else:
		$YSort/NPCs/PloyLibrary.queue_free()
		$YSort/Computer.queue_free()
		# Otherwise Ploy is with her grandmother
