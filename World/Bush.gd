extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var dialog = [tr("_do_you_want_to_use_your_spell_dtat_to_cut_this_bush_q_yes_no")]
const DTAT_WORD_ID = 401
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func remove_following_spell():
	# todo: it could be good to remove the oldest one that corresponds to the word_id
	# But it doesn't matter too much since there's an infinite source of this word now.
	var new_following_spells = []
	var word_is_removed = false
	for following_spell in Game.following_spells:
		if not word_is_removed and following_spell.id == DTAT_WORD_ID:
			word_is_removed = true
			following_spell.over_word.starts_disappearing()
		else:
			new_following_spells.append(following_spell)
	Game.following_spells = new_following_spells

func dialog_option(parameters):
	var dialog_node = parameters[0]
	var chosen_option = parameters[1]
	if chosen_option == 2:
		return
	remove_following_spell()
	queue_free()

func interact():
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog, self, null, false, null)
	Game.current_scene.add_child(Game.current_dialog)

func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	var there_is_an_available_cut_spell = false
	for following_spell in Game.following_spells:
		if following_spell.id == DTAT_WORD_ID:
			there_is_an_available_cut_spell = true
	if not there_is_an_available_cut_spell:
		return
	Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if not body == Game.player:
		return
	Game.lose_focus(self)