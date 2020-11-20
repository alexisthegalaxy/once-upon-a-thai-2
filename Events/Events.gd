extends Node

var initial_state = true
var events = {
	"ploy_has_stopped_in_front_of_house": initial_state,
	"has_met_ploy": initial_state,
	"has_met_pet": initial_state,
	"has_learnt_four_first_words": initial_state,
	"yaai_has_given_last_warning_before_forest": initial_state,
	"yaai_explains_rock": initial_state,
	"has_gone_to_rock": initial_state,
	"has_finished_the_letter_world_the_first_time": initial_state,
	"can_see_the_looking_for_letter_banner": initial_state,
	"has_been_in_the_letter_world": initial_state,
	"ceremony_started": initial_state,
	"yaai_went_to_forest_entrance": initial_state,
	"talked_to_yaai_for_the_first_time": initial_state,
	"talked_to_nim_at_the_beginning": initial_state,
}

var var_1 = null  # let's find a cleaner way
var var_2 = null  # let's find a cleaner way

#func lose_focus(_parameters):
#	for focus in Game.current_focus:
#		Game.loses_focus(focus)

func show_looking_for_letters(_parameters):
	events["can_see_the_looking_for_letter_banner"] = true
	Game.looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
	Game.looking_for_letter__node.init(Game.letters_we_look_for)
	Game.current_scene.add_child(Game.looking_for_letter__node)
	Game.current_scene.get_node("YSort").get_node("Door Vowels").init_letters()
	Game.current_scene.get_node("YSort").get_node("Door Accents").init_letters()
	Game.current_scene.get_node("YSort").get_node("Door MC").init_letters()
	Game.current_scene.get_node("YSort").get_node("Door HC").init_letters()
	Game.current_scene.get_node("YSort").get_node("Door LC").init_letters()
	
	
func nim_walks_to(parameters):
	events["talked_to_nim_at_the_beginning"] = true
	Game.current_focus[0].dialog = ["Granny is waiting for you outside.", "Be brave, okay?"]
	npc_walks_to(parameters)
	
func yaai_walks_to(parameters):
	events["talked_to_yaai_for_the_first_time"] = true
	if not Game.current_focus:
		Game.current_focus.append(Game.current_scene.get_node("YSort").get_node("NPCs").get_node("Yaai"))
	npc_walks_to(parameters)
#	var target_positions = parameters[0]
#	Game.current_focus.will_go_to = target_positions
#	if target_positions:
#		Game.current_focus.starts_going_toward(target_positions[0])
#	else:
#		print('nowhere to go!')

func npc_walks_to(parameters):
	var target_positions = parameters[0]
	if Game.current_focus:
		Game.current_focus[0].will_go_to = target_positions
		if target_positions:
			Game.current_focus[0].starts_going_toward(target_positions[0])
		else:
			print('nowhere to go!')
	else:
		print('Error: Game.current_focus shouldnt be empty')

func npc_disappears_in_white_orb(parameters):
	var npc = parameters[0]
	npc.disappear_in_white_orb()

func learns_first_sentence(calling_npc):
	Game.lose_focus(Game.current_focus)
	Game.discovers_sentence(196, true)
	calling_npc.dialog = [
		"Well done [Name]!",
		"Now, your test will be to guess the meaning of all words you will find deeper in the forest.",
		"I believe four types of Spells live there.",
		"Good luck, I'll watch you from here.",
		]
	calling_npc.post_dialog_event = ["set_yaai_has_given_last_warning_before_forest_as_true", []]

func say_sentence(sentence_id):
	Game.lose_focus(Game.current_focus)
	Game.discovers_sentence(sentence_id, false)
	
func teach_sentence(sentence_id):
	Game.lose_focus(Game.current_focus)
	Game.discovers_sentence(sentence_id, true)

func set_yaai_has_given_last_warning_before_forest_as_true(_parameters):
	events.yaai_has_given_last_warning_before_forest = true

func immediately_enters_lexical_world():
	Game.call_deferred("_deferred_goto_scene", "res://Maps/LexicalWorld/LetterHub.tscn", 13, 71.66)

func enters_lexical_world(_parameters):
	# Blackens the screen, and then call immediately_enters_lexical_world
	Game.current_scene.blackens()
	var timer = Timer.new()
	Game.can_move = false
	timer.connect("timeout", self, "immediately_enters_lexical_world")
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	timer.autostart = true
	add_child(timer)
	timer.start()

#	var target_positions = [
#		Vector2(266.69, 528.84),
#		Vector2(273.62, 623.76),
#		Vector2(226.68, 635.33),
#	]
#	Game.current_focus.will_go_to = target_positions
#	if target_positions:
#		Game.current_focus.starts_going_toward(target_positions[0])

func ploy_goes_towards_the_temple(ploy):
	events.ploy_has_stopped_in_front_of_house = true
	ploy.will_go_to = [
		Vector2(995, 116),
		Vector2(1191, 116),
		Vector2(1191, 256),
		Vector2(1294, 260),
		Vector2(1298, 177),
		"disappears"
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.post_dialog_event = []
	ploy.dialog = [
		"Come in!",
	]
	

func ploy_goes_towards_her_house(ploy):
	ploy.will_go_to = [
		Vector2(990, 125),
		Vector2(990, 90)
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.dialog = [
		"My mom and dad are at home, they’ll teach you sentences if you go see them!",
		"But later, follow me to the temple first!",
	]
	ploy.post_dialog_event = ["ploy_goes_towards_the_temple", ploy]

func ploy_cuts_bush(parameters):
	var ploy = parameters[0]
	var_1 = parameters[1]
	var_2 = ploy
	ploy.will_go_to = [
		Vector2(689, 88),
		Vector2(689, 110)
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.dialog = [
		"Cool, right?",
		"My grandmother taught me this Spell during my initiation.",
		"Oh by the way I just saw Pet! This guy is always such a jerk!",
		"Anyways. Follow me!",
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
	var_1.queue_free()

func ploy_talks_again():
	var_2.interact()

func ceremony_special_effect(_parameters):
#	Game.current_scene.
	pass

func execute(event_id, parameters):
	call(event_id, parameters)
