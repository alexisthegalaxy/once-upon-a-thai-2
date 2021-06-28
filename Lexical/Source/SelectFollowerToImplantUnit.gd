extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var word_id
var over_source

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_select_follower_to_implant_unit(_word_id, _over_source):
	word_id = _word_id
	over_source = _over_source
	$Button.text = Game.words[str(_word_id)].th

func remove_following_word():
	# todo: it could be good to remove the oldest one that corresponds to the word_id
	# But it doesn't matter too much since there's an infinite source of this word now.
	var following_words = []
	var word_is_removed = false
	for following_word in Game.following_words:
		if not word_is_removed and following_word.id == word_id:
			word_is_removed = true
			following_word.over_word.starts_disappearing()
		else:
			new_following_words.append(following_word)
	Game.following_words = new_following_words

func _on_Button_pressed():
	if not over_source:
		# Then we cast the spell
		# TODO
		Game.select_follower_to_implant_screen.queue_free()
		Game.select_follower_to_implant_screen = null
		remove_following_word()
	if over_source:
		Quests.update_implant_source_with_this_word_quests(over_source.name, word_id)
		Game.select_follower_to_implant_screen.queue_free()
		Game.select_follower_to_implant_screen = null
		over_source.word_ids.append(word_id)
		over_source.update_source(false)
		remove_following_word()
		over_source.update_game_sources()
