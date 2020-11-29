extends CanvasLayer

var sentence_y = 75
var sentence_x = 50

func _ready():
	Game.deducing_coop_select_sentence_screen = self
	for sentence_id in Game.seen_sentences:
		var select_sentence_unit = load("res://Test/DeducingCoop/DeducingCoopSelectSentenceUnit.tscn").instance()
		select_sentence_unit.init_select_sentence_unit(sentence_id)
		select_sentence_unit.position.x = sentence_x
		select_sentence_unit.position.y = sentence_y
		self.add_child(select_sentence_unit)
		sentence_y += 25
