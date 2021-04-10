extends Node

var is_blackening = false
var alpha = 0
var province = "chaiyaphum"

# This is the letters yaai asks us to fetch the first time we come in the Memory Palace
#var initial_letters = [0, 6, 9, 11, 13, 17, 19, 21, 28, 36]  # outdated
#var initial_letters = [11, 13, 28, 0, 21]  # correct
var initial_letters = [0]

var lo = TranslationServer.get_locale()

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
		$YSort/NPCs/Yaai.set_direction("down")
		$YSort/NPCs/Yaai.dialog = [
			tr("_now_your_test_will_be_to"),
			tr("_i_believe_four_types_of_spells_live_there"),
			tr("_good_luck_ill_watch_you_from_here"),
		]
		$YSort/NPCs/Yaai.post_dialog_event = []
#	elif Events.events.has_gone_to_first_sentence:
#		$YSort/NPCs/Yaai.position = Vector2(202.29, 654.29)
#		$YSort/NPCs/Yaai.set_direction("right")
	elif Events.events["yaai_went_to_the_tree"]:
		$YSort/NPCs/Yaai.position = Vector2(245.153534, 523.72229)
		$YSort/NPCs/Yaai.set_direction("right")
		$YSort/NPCs/Yaai.post_dialog_event = []
	elif Events.events["talked_to_yaai_for_the_first_time"]:
		$YSort/NPCs/Yaai.position = Vector2(478.02533, 502.912994)
		$YSort/NPCs/Yaai.set_direction("right")
		$YSort/NPCs/Yaai.post_dialog_event = []

func _process(delta):
	if is_blackening:
		alpha += delta
		$CanvasLayer/BlackFadeOut.modulate = Color(1, 1, 1, alpha)
#
func _on_First_blocker_body_entered(body):
	# Blocker 1 - also the trigger for pet
	if not body == Game.player:
		return
	if not Events.events.has_learnt_four_first_words:
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		var dialog = [
			tr("_i_shouldnt_go_there_now")
		]
		Game.current_dialog.init_dialog(dialog, self, null, false, null)
		Game.player.stop_walking()
		Game.current_scene.add_child(Game.current_dialog)
		Game.player.forced_toward(Vector2(553, 442))
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
	$YSort/NPCs/Pet.will_go_to = [
		Vector2 (528, 298),
		Vector2(534.0, 254.6),
		Vector2(504.0, 254.6),
	]
	$YSort/NPCs/Pet.starts_going_toward($YSort/NPCs/Pet.will_go_to[0])

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
	# Yaai is waiting for us at the forest entrance
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["yaai_went_to_the_tree"]:
			Events.events["yaai_went_to_the_tree"] = true
			$YSort/NPCs/Yaai.will_go_to = [
				Vector2(235.153534, 523.72229),
				Vector2(245.153534, 523.72229),
			]
			$YSort/NPCs/Yaai.starts_going_toward($YSort/NPCs/Yaai.will_go_to[0])

func _on_Area2D4_body_entered(body):
	# When we enter by the tree, Yaai starts the ceremony
	if body == Game.player:
		if not Events.events["ceremony_started"]:
			Events.events["ceremony_started"] = true
			$YSort/NPCs/Yaai.dialog = [
				tr("_yaai_2_a"),
				tr("_yaai_2_b"),
				tr("_yaai_2_c"),
				tr("_yaai_2_d"),
			]
			$YSort/NPCs/Yaai.post_dialog_event = ["starts_ceremony_effect", $YSort/NPCs/Yaai]
			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
			$YSort/NPCs/Yaai.interact()
			Game.letters_we_look_for = []
			for letter_id in initial_letters:
				Game.letters_we_look_for.append(Game.letters[str(letter_id)])

#func _on_Area2D3_body_entered(body):
#	# Player enters near the first sentence
#	if body == Game.player:
#		if Events.events["has_gone_to_first_sentence"] and not Events.events["yaai_taught_first_sentence"]:
#			Events.events["yaai_taught_first_sentence"] = true
#			$YSort/NPCs/Yaai.dialog = [
#				tr("_name_you_see_this_sentence"),
#				tr("_this_is_your_first_since_forgotten_thai"),
#				tr("_this_means_thai_people_are_good"),
#				tr("_sentences_like_this_help_you_understand_the_meaning_of_words"),
#			]
#			$YSort/NPCs/Yaai.post_dialog_event = ["learns_first_sentence", $YSort/NPCs/Yaai]
#			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
#			$YSort/NPCs/Yaai.interact()

func _on_Area2D6_body_entered(body):
	if not body == Game.player:
		return
	# This is the area that leads into the first forest.
	# It can be used the first time for Yaai warning,
	# and the second time for Yaai's instruction to go to Chaiyaphum
#	if not Events.events.yaai_has_given_last_warning_before_forest and Events.events.yaai_taught_first_sentence:
#		Events.events.yaai_has_given_last_warning_before_forest = true
#		$YSort/NPCs/Yaai.dialog = [
#			tr("_well_done_name"),
#			tr("_now_your_test_will_be_to"),
#			tr("_i_believe_four_types_of_spells_live_there"),
#			tr("_good_luck_ill_watch_you_from_here"),
#			]
#		$YSort/NPCs/Yaai.post_dialog_event = []
#		$YSort/NPCs/Yaai.interact()
		
	if not Events.events.has_learnt_four_first_words:
		if 343 in Game.known_words and 345 in Game.known_words and 207 in Game.known_words and 82 in Game.known_words:
			Events.events.has_learnt_four_first_words = true
			set_events_when_has_learnt_four_first_words()
			$YSort/NPCs/Yaai.interact()

func set_events_when_has_learnt_four_first_words():
	$YSort/NPCs/Yaai.dialog = [
		tr("_thats_good_name_very_good"),
		tr("_now_go_to_chaiyaphum_see_anchalee"),
		tr("_i_have_important_issues_to_solve_in_the_spirit_world"),
		tr("_if_everything_goes_well_ill_see_you_soon"),
	]
	$YSort/NPCs/Yaai.start_quests = ["talk_to_anchalee_in_chaiyaphum"]
	$YSort/NPCs/Yaai.post_dialog_event = ["npc_disappears_in_white_orb", [$YSort/NPCs/Yaai]]

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
				SoundPlayer.play_sound("res://Sounds/Effects/correct.wav", 0)
			else:
				npc.dialog = [tr("_see_bpai_is_written_i_go_to_chaiyaphum_loser")]
				dialog_node.dialog = npc.dialog
				dialog_node.page = -1
				SoundPlayer.play_sound("res://Sounds/Effects/wrong.wav", 0)
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

func _on_Blocker2_body_entered(body):
	# Blocker 2
	if not body == Game.player:
		return
	if Events.events.yaai_taught_first_sentence:  # We've already learned the sentence
		return
#	if not Events.events.talked_to_yaai_for_the_first_time:
	if knows_the_initial_letters():
		Quests.quests["find_first_words__when_learning_letters"][lo+"_start_dialog"].append(tr("_yaai_i_should_teach_sentence"))
		Events.events["yaai_taught_first_sentence"] = true
		$YSort/NPCs/Yaai.post_dialog_event = ["learns_first_sentence", $YSort/NPCs/Yaai]
		$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
		$YSort/NPCs/Yaai.npc_turn_towards(Game.player.position)
		$YSort/NPCs/Yaai.dialog = [tr("_yaai_i_should_teach_sentence")]
		$YSort/NPCs/Yaai.interact()
		return
	# Then we are blocked!
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	var dialog = [
		tr("_you_shouldnt_go_there_before_you_know_letters"),
		tr("_click_on_the_letter_tab_to_use_the_letter_scroll")
	]
	$YSort/NPCs/Yaai.npc_turn_towards(Game.player.position)
	Game.current_dialog.init_dialog(dialog, $YSort/NPCs/Yaai, null, false, null)
	Game.player.stop_walking()
	Game.current_scene.add_child(Game.current_dialog)
	Game.player.forced_toward(Vector2(236, 550))
		
func knows_the_initial_letters():
	for initial_letter_id in initial_letters:
		if not initial_letter_id in Game.known_letters:
			return false
	return true

func _on_Blocker3_body_entered(body):
	if not body == Game.player:
		return
#	If we haven't learned the four words, we can't cross this zone!
	if Events.events.has_learnt_four_first_words or not Events.events.ceremony_started:
		return
	if not (Game.can_read_thai or knows_the_initial_letters()):
		var dialog = [
			tr("_before_you_go_there_learn_the_letters_1"),
			tr("_before_you_go_there_learn_the_letters_2"),
		]
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		Game.current_dialog.init_dialog(dialog, $YSort/NPCs/Yaai, null, false, null)
		$YSort/NPCs/Yaai.npc_turn_towards(Game.player.position)
		Game.player.stop_walking()
		Game.current_scene.add_child(Game.current_dialog)
		Game.player.forced_toward(Vector2(318, 523))
