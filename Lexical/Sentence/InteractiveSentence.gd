extends Node2D

var words = []
var children = []

func init_interactive_sentence(sentence, main_word_id, hears_sentence_immediately, see_audio_player, see_translation):
	var current_x = 0
	for child in children:
		child.queue_free()
	children = []

	var playable_sentence = sentence["th"]
	if hears_sentence_immediately:
		SoundPlayer.play_thai(playable_sentence)
	if see_audio_player:
		$Node2D/TestSoundPlayer.show()
	else:
		$Node2D/TestSoundPlayer.hide()
	if see_translation:
		$Node2D/Translation.show()
	else:
		$Node2D/Translation.hide()
	$Node2D/TestSoundPlayer.init_sound_player(playable_sentence)
	if sentence.id in Game.known_sentences:
		$Node2D/Translation.text = DistractorsHelper.get_sentence_source_text(sentence)
	else:
		$Node2D/Translation.text = tr("_unknown_meaning")
	for word_id in sentence["word_ids"]:
		var word = Game.words[str(word_id)]
		var is_main_word = word_id == main_word_id
		words.append(word)
		var word_instance = load("res://Test/WordInSentenceCarousel.tscn").instance()
		
		word_instance.position.x = current_x
		word_instance.init_word_in_sentence(word_id, is_main_word)
		current_x += word_instance.width
		add_child(word_instance)
		children.append(word_instance)
	
	# Let's center everything
	var center_x = current_x / 2
	for word in children:
		word.position.x -= center_x
	$Node2D.position.x = -$Node2D/Translation.get_minimum_size()[0] / 2
