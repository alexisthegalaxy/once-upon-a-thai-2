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

func remove_following_spell():
	# todo: it could be good to remove the oldest one that corresponds to the word_id
	# But it doesn't matter too much since there's an infinite source of this word now.
	var new_following_spells = []
	var word_is_removed = false
	for following_spell in Game.following_spells:
		if not word_is_removed and following_spell.id == word_id:
			word_is_removed = true
			following_spell.over_word.starts_disappearing()
		else:
			new_following_spells.append(following_spell)
	Game.following_spells = new_following_spells

func _on_Button_pressed():
	Quests.update_implant_source_with_this_word_quests(over_source.name)
	Game.select_follower_to_implant_screen.queue_free()
	Game.select_follower_to_implant_screen = null
	over_source.word_ids.append(word_id)
	over_source.update_source(false)
	remove_following_spell()
