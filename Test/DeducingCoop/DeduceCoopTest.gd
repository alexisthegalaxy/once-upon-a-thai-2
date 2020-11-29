extends CanvasLayer

var sentence_id
var sentence

func init_deduce_coop_test(_sentence_id):
	Game.deducing_coop_select_sentence_screen.queue_free()
	Game.deducing_coop_select_sentence_screen = null
	sentence_id = str(_sentence_id)
	sentence = Game.sentences[sentence_id]
	Game.active_test = self
	$InteractiveSentence.init_interactive_sentence(sentence, null, false, false, false)
