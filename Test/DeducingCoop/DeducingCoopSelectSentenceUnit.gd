extends Node2D

var sentence_id
var sentence

func init_select_sentence_unit(_sentence_id: int):
	sentence_id = str(_sentence_id)
	sentence = Game.sentences[sentence_id]
	$Indicator.hide()
	$InteractiveSentence.init_interactive_sentence(sentence, null, false, false, false)

func _on_Button_mouse_entered():
	$Indicator.show()
	var playable_sentence = sentence["th"].replace("_", "").replace("-", "")
	SoundPlayer.play_thai(playable_sentence)

func _on_Button_mouse_exited():
	$Indicator.hide()

func _on_Button_pressed():
	var deduce_coop_test_screen = load("res://Test/DeducingCoop/DeduceCoopTest.tscn").instance()
	deduce_coop_test_screen.init_deduce_coop_test(sentence_id)
	Game.current_scene.add_child(deduce_coop_test_screen)
