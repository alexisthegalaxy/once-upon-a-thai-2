extends StaticBody2D

#export(bool) var is_corrupted = false
export(String) var type = "SacredRock"
export(Array, int) var word_ids = [1]
export(int) var max_number_of_words = 3
export(int) var wait_time = 12
var time = 0
var rng = RandomNumberGenerator.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	var main_sprite = "res://World/assets/" + type + ".png"
	var pulsating_sprite = "res://World/assets/Pulsing" + type + ".png"
	var light_sprite = "res://World/assets/" + type + "Light.png"
#	print(main_sprite)
#	print(pulsating_sprite)
#	print(light_sprite)
	$Sprite.texture = load(main_sprite)
	$PulsatingSprite.texture = load(pulsating_sprite)
	$Light.texture = load(light_sprite)
	
	rng.randomize()
	update_source(true)

func update_source(spawn_immediately):
	$Spawner.init_word_spawner(word_ids, max_number_of_words, wait_time, spawn_immediately)
	if word_ids:
		$PulsatingSprite.show()
		$Light.show()
	else:
		$PulsatingSprite.hide()
		$Light.hide()

func _process(delta):
	if word_ids:
		time += delta
		var ondulation = cos(time)
		var alpha = 0.7 - 0.3 * ondulation
#		$Light.modulate = Color(1, 1, 1, alpha)
		$Light.energy = alpha
		$PulsatingSprite.modulate = Color(1, 1, 1, alpha)

func interact():
	var dialog
	if word_ids:
		if len(word_ids) == 1:
			dialog = [
				tr("_it_looks_like_the_spell") + Game.words[str(word_ids[0])].th + tr("_lives_inside_that_source"),
				tr("_do_you_want_to_take_it_out")
			]
		else:
			dialog = [tr("_it_looks_like") + str(len(word_ids)) + tr("_different_words_live_inside_that_source")]
	else:
		if len(Game.following_spells) == 1:
			var thai = Game.words[str(Game.following_spells[0].id)].th
			dialog = [tr("_this_is_a_source_it_is_currently_empty_do_you_want_to_house_the_spell") + thai + tr("_inside_q_yes_no")]
		else:
			dialog = [tr("_this_is_a_source_empty+house_spell_inside")]
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.lose_focus(null)
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog, self, null, false, null)
	Game.current_scene.add_child(Game.current_dialog)

func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if not body == Game.player:
		return
	Game.lose_focus(self)

func dialog_option(parameters):
	var dialog_node = parameters[0]
	var chosen_option = parameters[1]
	if len(word_ids) == 0:
		if chosen_option == 1:
			Game.lose_focus(null)
			if len(Game.following_spells) > 1:
				Game.select_follower_to_implant_screen = load("res://Lexical/Source/SelectFollowerToImplant.tscn").instance()
				Game.select_follower_to_implant_screen.init_select_follower_to_implant_screen(self)
				Game.current_scene.add_child(Game.select_follower_to_implant_screen)
			elif len(Game.following_spells) == 1:
				word_ids.append(Game.following_spells[0].id)
				update_source(false)
				Game.following_spells[0].over_word.starts_disappearing()
				Game.following_spells = []
			else:
				Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
				var dialog = [tr("_you_dont_have_any_spell_come_back_with_spells")]
				Game.current_dialog.init_dialog(dialog, null, null, null, null)
				Game.current_scene.add_child(Game.current_dialog)
	elif len(word_ids) == 1:
		if chosen_option == 1:
			var new_word = load("res://Lexical/Word/Spell.tscn").instance()
			new_word.id = word_ids[0]
			new_word.word = Game.words[str(word_ids[0])]
			new_word.can_move = true
			new_word.position = get_global_position()
			Game.current_scene.get_node("YSort").add_child(new_word)
#			Game.following_spells.append({
#				"id": word_ids[0],
#				"over_word": new_word,
#			})
			word_ids = []
			update_source(false)
			
