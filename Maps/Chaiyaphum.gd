extends Node

var is_blackening = false
var alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.events.ploy_has_stopped_in_front_of_house:
		$YSort/NPCs/Ploy.queue_free()
		$YSort/Bushes/BushThatWillGetCut.queue_free()
	yaai_arc()
	if Events.events.has_met_pet:
		$YSort/NPCs/Pet.position = Vector2(1074.783936, 94.056053)
		$YSort/NPCs/Pet.dialog = pet_begging_dialog()

	# we remove the shard
	if Quests.quests["purify_mohinkhao"].status in [Quests.FINISHED, Quests.DONE]:
		$YSort/Shards/MoHinKhao.queue_free()

func yaai_arc():
	if Events.events.has_learnt_four_first_words:
		set_events_when_has_learnt_four_first_words()
	elif Events.events.yaai_has_given_last_warning_before_forest:
		$YSort/NPCs/Yaai.position = Vector2(196, 652)
		$YSort/NPCs/Yaai.direction = "down"
		$YSort/NPCs/Yaai.update_animation()
		$YSort/NPCs/Yaai.dialog = [
			tr("_now_your_test_will_be_to"),
			tr("_i_believe_four_types_of_spells_live_there"),
			tr("_good_luck_ill_watch_you_from_here"),
		]
		$YSort/NPCs/Yaai.post_dialog_event = []
	elif Events.events.has_gone_to_first_sentence:
		$YSort/NPCs/Yaai.position = Vector2(202.29, 654.29)
		$YSort/NPCs/Yaai.direction = "right"
		# when we'll try to get close to her, she'll explain the sentence
	elif Events.events["has_finished_the_letter_world_the_first_time"]:
		Events.events["has_gone_to_first_sentence"] = true
		Game.player.can_interact = false
		Game.is_frozen = true
		$YSort/NPCs/Yaai.position = Vector2(207.81, 513.20)
		$YSort/NPCs/Yaai.dialog = [
			tr("_welcome_back_name"),
			tr("_you_can_always_go_back_to_your_memory_palace"),
			tr("_for_now_follow_me_into_the_forest"),
		]
		$YSort/NPCs/Yaai.post_dialog_event = ["yaai_walks_to", [[
			Vector2(285.5, 561.6),
			Vector2(247, 619.5),
			Vector2(199, 652.5),
			Vector2(205, 655.57),
		]]]
		$YSort/NPCs/Yaai.call_deferred("interact")
	elif Events.events["yaai_went_to_forest_entrance"]:
		$YSort/NPCs/Yaai.position = Vector2(207.81, 513.20)
	elif Events.events["talked_to_yaai_for_the_first_time"]:
		$YSort/NPCs/Yaai.position = Vector2(490, 260)

func _process(delta):
	if is_blackening:
		alpha += delta
		$CanvasLayer/BlackFadeOut.modulate = Color(1, 1, 1, alpha)

func _on_Area2D5_body_entered(body):
	# Blocker 1
	if body == Game.player:
		if not Events.events.talked_to_yaai_for_the_first_time:
			Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				tr("_i_should_talk_to_my_grandmother_first")
			]
			Game.current_dialog.init_dialog(dialog, self, null, false, null)
			Game.player.stop_walking()
			Game.current_scene.add_child(Game.current_dialog)
			Game.player.forced_toward(Vector2(553, 442))

func _on_Area2D_body_entered(body):
	# Blocker 2
	if body == Game.player:
		if not Events.events.has_learnt_four_first_words:
			Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				tr("_i_shouldnt_go_there_now")
			]
			Game.current_dialog.init_dialog(dialog, self, null, false, null)
			Game.player.stop_walking()
			Game.current_scene.add_child(Game.current_dialog)
			Game.player.forced_toward(Vector2(541, 240))

func _on_Area2D2_body_entered(body):
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["yaai_went_to_forest_entrance"]:
			Events.events["yaai_went_to_forest_entrance"] = true
			$YSort/NPCs/Yaai.will_go_to = [
				Vector2(424.345886, 258.342377),
				Vector2(386.262726, 289.715057),
				Vector2(329.735779, 262.521484),
				Vector2(276.05658, 267.983002),
				Vector2(230.951202, 318.291962),
				Vector2(151.844299, 356.405609),
				Vector2(82.644707, 418.610535),
				Vector2(96.330925, 486.941467),
				Vector2(162.271317, 516.195312),
				Vector2(275.153534, 523.72229)
			]
			$YSort/NPCs/Yaai.starts_going_toward($YSort/NPCs/Yaai.will_go_to[0])

func _on_Area2D4_body_entered(body):
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["ceremony_started"]:
			Events.events["ceremony_started"] = true
			$YSort/NPCs/Yaai.dialog = [
				tr("_heres_the_place_and_time"),
				tr("_lets_start_your_shaman_initiation"),
				tr("_once_you_drink_this"),
				tr("_but_theres_a_cost"),
				tr("_youll_forget_thai"),
				tr("_you_trade_thai_for_power"),
				tr("_if_you_ready_drink_this"),
				tr("_name_drink_potion"),
			]
			$YSort/NPCs/Yaai.post_dialog_event = ["enters_lexical_world", null]
			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
			$YSort/NPCs/Yaai.interact()
			Game.letters_we_look_for = []
			for letter_id in Game.initial_letters:
				Game.letters_we_look_for.append(Game.letters[str(letter_id)])

func _on_Area2D3_body_entered(body):
	# Player enters near the first sentence
	if body == Game.player:
		if Events.events["has_gone_to_first_sentence"] and not Events.events["yaai_explains_first_sentence"]:
			Events.events["yaai_explains_first_sentence"] = true
			$YSort/NPCs/Yaai.dialog = [
				tr("_name_you_see_this_sentence"),
				tr("_this_is_your_first_since_forgotten_thai"),
				tr("_this_means_thai_people_are_good"),
				tr("_sentences_like_this_help_you_understand_the_meaning_of_words"),
			]
			$YSort/NPCs/Yaai.post_dialog_event = ["learns_first_sentence", $YSort/NPCs/Yaai]
			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
			$YSort/NPCs/Yaai.interact()

func _on_Area2D6_body_entered(body):
	if not body == Game.player:
		return
	# This is the are athat leads into the first forest.
	# It can be used the first time for Yaai warning,
	# and the second time for Yaai's instruction to go to Chaiyaphum
	if not Events.events.yaai_has_given_last_warning_before_forest and Events.events.yaai_explains_first_sentence:
		Events.events.yaai_has_given_last_warning_before_forest = true
		$YSort/NPCs/Yaai.dialog = [
			tr("_well_done_name"),
			tr("_now_your_test_will_be_to"),
			tr("_i_believe_four_types_of_spells_live_there"),
			tr("_good_luck_ill_watch_you_from_here"),
			]
		$YSort/NPCs/Yaai.post_dialog_event = []
		$YSort/NPCs/Yaai.interact()
		
	if not Events.events.has_learnt_four_first_words:
		if 343 in Game.known_words and 345 in Game.known_words and 207 in Game.known_words and 82 in Game.known_words:
			Events.events.has_learnt_four_first_words = true
			set_events_when_has_learnt_four_first_words()
			$YSort/NPCs/Yaai.interact()

func set_events_when_has_learnt_four_first_words():
	$YSort/NPCs/PetsMom.dialog = [
		tr("_im_so_happy_for_pet_initiation_went_well"),
		tr("_hes_in_chaiyaphum_tell_him_to_drop_by")
	]
	$YSort/NPCs/Yaai.dialog = [
		tr("_thats_good_name_very_good"),
		tr("_now_go_to_chaiyaphum_see_anchalee"),
		tr("_i_have_important_issues_to_solve_in_the_spirit_world"),
		tr("_if_everything_goes_well_ill_see_you_soon"),
	]
	$YSort/NPCs/Yaai.start_quests = ["talk_to_anchalee_in_chaiyaphum"]
	$YSort/NPCs/Yaai.post_dialog_event = ["npc_disappears_in_white_orb", [$YSort/NPCs/Yaai]]
	$YSort/NPCs/Pet.position = Vector2(557.0, 432.6)

func _on_PetWillWalk_body_entered(body):
	if not body == Game.player:
		return
	if not Events.events.has_learnt_four_first_words:
		return
	if Events.events.has_met_pet:
		return
	$YSort/NPCs/Pet.interact_when_near = true
	$YSort/NPCs/Pet.dialog = [
		tr("_oh_hey_name"),
		tr("_what_you_finished_your_initiation"),
		tr("_tch_took_you_long_mine_finished_thirty_minutes_ago"),
		tr("_id_like_to_have_you_as_training_but_cant_match_intellect"),
		tr("_you_cant_even_write_bpai"),
	]
	$YSort/NPCs/Pet.position = Vector2(557.0, 532.6)
	$YSort/NPCs/Pet.will_go_to = [
		Vector2 (519.2, 375.6),
		Vector2(534.0, 254.6),
		Vector2(504.0, 254.6),
	]
	$YSort/NPCs/Pet.starts_going_toward($YSort/NPCs/Pet.will_go_to[0])

func _on_PloyWillCome_body_entered(body):
	if not body == Game.player:
		return
	if not Events.events.has_met_ploy:
		Events.events.has_met_ploy = true
		$YSort/NPCs/Ploy.interact_when_near = true
		$YSort/NPCs/Ploy.dialog = [
			tr("_name_how_was_your_shamanic_initiation"),
			tr("_mine_went_well_too_my_grandma_taught_me_cool_stuff"),
			tr("_look_exclamation_mark")
		]
		$YSort/NPCs/Ploy.will_go_to = [
			Vector2(992, 117.146461),
			Vector2(790, 117.146461),
		]
		$YSort/NPCs/Ploy.post_dialog_event = ["ploy_cuts_bush", [$YSort/NPCs/Ploy, $YSort/Bushes/BushThatWillGetCut]]
		$YSort/NPCs/Ploy.starts_going_toward($YSort/NPCs/Ploy.will_go_to[0])

func _on_PloyInFrontOfHouse_body_entered(body):
	if not body == Game.player:
		return
	if Events.events.ploy_has_stopped_in_front_of_house:
		return
	
	Events.events.ploy_has_stopped_in_front_of_house = true
	$YSort/NPCs/Ploy.is_walking_towards = []
	$YSort/NPCs/Ploy.interact()


func _on_EnterSomber_body_entered(body):
	if not body == Game.player:
		return
	if Game.is_somber:  # somber already, then nothing to do
		return
	if not $YSort/Shards/MoHinKhao:
		return
	Game.starts_somber_mood()

func _on_ExitSomber_body_entered(body):
	if not body == Game.player:
		return
	if not Game.is_somber:  # not somber already, then nothing to do
		return
	Game.exits_somber_mood()

func pet_begging_dialog():
	return [
		tr("_pet_money_dialog_1"),
		tr("_pet_money_dialog_2"),
	]

func handle_dialog_option(dialog_node, answer_index, npc):
	if npc.name == "Pet":
		if not Events.events.has_met_pet:
			Events.events.has_met_pet = true
			if answer_index == 3:
				npc.dialog = [tr("_hmph_yeah_anyway_i_to_to_chaiyaphum_loser")]
				dialog_node.dialog = npc.dialog
				dialog_node.page = -1
				SoundPlayer.play_sound("res://Sounds/ding.wav", 0)
			else:
				npc.dialog = [tr("_see_bpai_is_written_i_go_to_chaiyaphum_loser")]
				dialog_node.dialog = npc.dialog
				dialog_node.page = -1
				SoundPlayer.play_sound("res://Sounds/incorrect.wav", 0)
			npc.post_dialog_event = ["npc_walks_to_and_get_new_dialog", [[
				Vector2(543.984375, 244.238388),
				Vector2(543.984375, 100.238388),
				Vector2(359.984375, 100.238388),
				Vector2(359.984375, 54.238388),
				Vector2(438.039154, -15.019601),
				Vector2(534.457153, -30.081276),
				Vector2(596.457153, -30.081276),
				Vector2(657.126892, 11.045315),
				Vector2(782.301086, 115.493446),
				Vector2(1074.358643, 120.03302),
				Vector2(1074.358643, 90.03302),
			], npc, pet_begging_dialog()]]
			dialog_node.post_dialog_event = npc.post_dialog_event
			dialog_node.caller.interact_when_near = false
		else:
			if answer_index == 1 and Game.money >= 15:  # YES
				npc.dialog = [tr("_pet_money_dialog_ok_1"), tr("_pet_money_dialog_ok_2")]
				dialog_node.dialog = npc.dialog
				dialog_node.page = -1
				Money.spends_money(15)
			else:  # NO or not enough
				npc.dialog = [tr("_pet_money_dialog_not_enough")]
				dialog_node.dialog = npc.dialog
				dialog_node.page = -1

