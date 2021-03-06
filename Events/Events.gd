extends Node

var initial_state = true
var state_2 = true
var state_3 = true
var events = {
	"can_see_palace": true,
	"money_is_visible": state_2,
	"has_the_map": state_2,
	"ploy_has_stopped_in_front_of_house": state_2,
	"has_met_ploy": state_2,
	"has_met_pet": state_2,
	"yaai_has_disappeared": state_2,
	"has_learnt_four_first_words": state_3,
	"yaai_has_given_last_warning_before_forest": state_3,
	"yaai_taught_first_sentence": state_3,  # should use known_sentences instead
	"has_had_a_quest": state_3,
	"ceremony_started": state_3,
	"known_words_are_visible": state_3,
	"yaai_went_to_the_tree": state_3,
	"talked_to_yaai_for_the_first_time": state_3,
	"talked_to_nim_at_the_beginning": state_3,
}

var var_1 = null  # let's find a cleaner way
var var_2 = null  # let's find a cleaner way

func save_game():
	return events

func load_game(events_data):
	if not events_data:
		return
	for event_name in events:
		if event_name in events_data:
			events[event_name] = events_data[event_name]

# Commented since April 6 2021
#func lose_focus(_parameters):
#	for focus in Game.current_focus:
#		Game.loses_focus(focus)

func nim_walks_to(parameters):
	events["talked_to_nim_at_the_beginning"] = true
	Game.current_focus[0].dialog = [
		tr("_granny_is_waiting_outside"),
		tr("_be_brave_okay")
		]
	npc_walks_to(parameters)
	
func yaai_walks_to(parameters):
	events["talked_to_yaai_for_the_first_time"] = true
	if not Game.current_focus:
#		Game.current_focus.append(Game.current_scene.get_node("YSort").get_node("NPCs").get_node("Yaai"))
		Game.current_focus.append(Game.current_scene.get_node("YSort/NPCs/Yaai"))
	npc_walks_to(parameters)
#	var target_positions = parameters[0]
#	Game.current_focus.will_go_to = target_positions
#	if target_positions:
#		Game.current_focus.starts_going_toward(target_positions[0])
#	else:
#		print('nowhere to go!')

func npc_walks_to_and_get_new_dialog(parameters):
	var npc = npc_walks_to(parameters) # the npc starts moving
	npc.dialog = parameters[2]

func npc_walks_to(parameters):
	var target_positions = parameters[0]
	var npc = null
	if Game.current_focus:
		npc = Game.current_focus[0]
	else:
		npc = parameters[1]
	npc.will_go_to = target_positions
	if target_positions:
		npc.starts_going_toward(target_positions[0])
	else:
		print('nowhere to go!')
	return npc

func npc_teaches_discreetly_words(word_ids):
	for word_id in word_ids:
		Game.known_words.append(word_id)

func npc_disappears_in_white_orb(parameters):
	var npc = parameters[0]
	if npc.name == "Yaai":
		Events.events.yaai_has_disappeared = true
	if npc:
		npc.disappear_in_white_orb()

func learns_first_sentence(calling_npc):
	Events.events["yaai_taught_first_sentence"] = true
	Game.lose_focus(Game.current_focus)
	Game.discovers_sentence(196, true)
	calling_npc.dialog = [
		tr("_well_done_name"),
		tr("_now_your_test_will_be_to"),
		tr("_i_believe_four_types_of_spells_live_there"),
		tr("_good_luck_ill_watch_you_from_here"),
		]
	calling_npc.post_dialog_event = ["set_yaai_has_given_last_warning_before_forest_as_true", []]

func say_sentence(sentence_id):
	Game.discovers_sentence(sentence_id, false)
	
func teach_sentence(sentence_id):
	Game.discovers_sentence(sentence_id, true)

func starts_deducing_coop(_no_arguments_needed):
	Game.starts_deducing_coop()

func starts_vending(sold_entities):
	Game.starts_vending(sold_entities)

func starts_interaction_test(interaction_sentence_id_and_npc):
	var interaction_sentence_id = interaction_sentence_id_and_npc[0]
	var npc = interaction_sentence_id_and_npc[1]
	Game.starts_interaction_test(interaction_sentence_id, npc)

func starts_job_menu_screen(_no_arguments_needed):
	Game.starts_job_menu_screen()

func set_yaai_has_given_last_warning_before_forest_as_true(_parameters):
	events.yaai_has_given_last_warning_before_forest = true

func can_see_letters(_no_arguments_needed):
	Game.should_show_letters_button = true
	Game.main_ui.update_main_ui_letters_display()

func starts_ceremony_effect(yaai):
	var ceremony_effect = load("res://Effects/CeremonyEffect.tscn").instance()
	ceremony_effect.yaai = yaai
	Game.current_scene.add_child(ceremony_effect)

func ploy_goes_towards_the_temple(ploy):
	events.ploy_has_stopped_in_front_of_house = true
	ploy.will_go_to = [
		Vector2(1169.884033, 116.591766),
		Vector2(1169.884033, 278.591766),
		Vector2(1239.884033, 278.591766),
		Vector2(1236.884033, 236.591766),
		"disappears"
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.post_dialog_event = []
	ploy.dialog = [
		"Come in!",
	]

func ploy_goes_towards_her_house(ploy):
	# As soon as Ploy will enter in the area in front of her house, she will talk to Player
	ploy.will_go_to = [
		Vector2(1100, 125),
		Vector2(1100, 100)
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.dialog = [
		tr("_my_mom_and_dad_are_at_home"),
		tr("_but_later_follow_me_to_temple_first"),
	]
	ploy.post_dialog_event = ["ploy_goes_towards_the_temple", ploy]

func ploy_cuts_bush(parameters):
	var ploy = parameters[0]
	ploy.interact_when_near = false
	var_1 = parameters[1]
	var_2 = ploy
	ploy.will_go_to = [
		Vector2(689, 88),
		Vector2(689, 110)
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.dialog = [
		tr("_cool_right"),
		tr("_my_grandmother_taught_me_this_spell"),
		tr("_by_the_way_i_saw_pet"),
		tr("_anyways_follow_me"),
	]
	ploy.post_dialog_event = ["ploy_goes_towards_her_house", ploy]
	
	var timer = Timer.new()
	timer.connect("timeout", self, "destroy_bush")
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	timer.autostart = true
	timer.start()
	add_child(timer)
	
	var timer_2 = Timer.new()
	timer_2.connect("timeout", self, "ploy_talks_again")
	timer_2.set_wait_time(2.5)
	timer_2.set_one_shot(true)
	timer_2.autostart = true
	timer_2.start()
	add_child(timer_2)

func destroy_bush():
	SoundPlayer.play_sound("res://Sounds/Effects/cut.wav", 0)
	var_1.queue_free()

func ploy_talks_again():
	var_2.interact()

# Is this used? Commented 10 April 2021
#func ceremony_special_effect(_parameters):
##	Game.current_scene.
#	pass

func execute(event_id, parameters):
	call(event_id, parameters)
