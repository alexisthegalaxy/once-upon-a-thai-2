extends Node

var events = {
	"ploy_has_stopped_in_front_of_house": false,
	"has_met_ploy": false,
	"has_met_pet": false,
	"has_learnt_four_first_words": false,
	"yaai_has_given_last_warning_before_forest": false,
	"yaai_explains_rock": false,
	"has_gone_to_rock": false,
	"has_finished_the_letter_world_the_first_time": false,
	"can_see_the_looking_for_letter_banner": false,
	"has_been_in_the_letter_world": false,
	"ceremony_started": false,
	"yaai_went_to_forest_entrance": false,
	"talked_to_yaai_for_the_first_time": false,
	"talked_to_nim_at_the_beginning": false,
}

var bush = null  # let's find a cleaner way

func lose_focus(_parameters):
	for focus in Game.current_focus:
		Game.loses_focus(focus)

func show_looking_for_letters(_parameters):
	events["can_see_the_looking_for_letter_banner"] = true
#	print("  ---  ")
#	print("Inside show_looking_for_letters")
#	print("  ---  ")
	Game.looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
	Game.looking_for_letter__node.init(Game.letters_we_look_for)
	get_tree().current_scene.add_child(Game.looking_for_letter__node)
	get_tree().current_scene.get_node("YSort").get_node("Door Vowels").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door Accents").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door MC").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door HC").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door LC").init_letters()
	
	
func nim_walks_to(parameters):
	events["talked_to_nim_at_the_beginning"] = true
	Game.current_focus[0].dialog = ["Nim: Granny is waiting for you outside.", "Nim: Be brave, okay?"]
	npc_walks_to(parameters)
	
func yaai_walks_to(parameters):
	events["talked_to_yaai_for_the_first_time"] = true
	if not Game.current_focus:
		Game.current_focus.append(get_tree().current_scene.get_node("YSort").get_node("NPCs").get_node("Yaai"))
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
	Game.loses_focus(Game.current_focus)
	Game.discovers_sentence(196, true)
	calling_npc.dialog = [
		"Yaai: Well done [Name]!",
		"Yaai: Now, your test will be to guess the meannig of all words you will find deeper in the forest.",
		"Yaai: I believe four types of Spells live there.",
		"Yaai: Good luck, I'll watch you from here.",
		]
	calling_npc.post_dialog_event = ["set_yaai_has_given_last_warning_before_forest_as_true", []]

func say_sentence(sentence_id):
	Game.loses_focus(Game.current_focus)
	Game.discovers_sentence(sentence_id, false)
	
func teach_sentence(sentence_id):
	Game.loses_focus(Game.current_focus)
	Game.discovers_sentence(sentence_id, true)

func set_yaai_has_given_last_warning_before_forest_as_true():
	events.yaai_has_given_last_warning_before_forest = true

func immediately_enters_lexical_world():
	Game.call_deferred("_deferred_goto_scene", "res://Maps/LexicalWorld/LetterHub.tscn", 13, 71.66)

func enters_lexical_world(_parameters):
	# Blackens the screen, and then call immediately_enters_lexical_world
	get_tree().current_scene.blackens()
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
		"Ploy: Come in!",
	]
	

func ploy_goes_towards_her_house(ploy):
	ploy.will_go_to = [
		Vector2(990, 125),
		Vector2(990, 90)
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.dialog = [
		"Ploy: My mom and dad are at home, they’ll teach you sentences if you go see them!",
		"Ploy: But later, follow me to the temple first!",
	]
	ploy.post_dialog_event = ["ploy_goes_towards_the_temple", ploy]

func ploy_cuts_bush(parameters):
	var ploy = parameters[0]
	bush = parameters[1]
	ploy.will_go_to = [
		Vector2(689, 88),
		Vector2(689, 110)
	]
	ploy.starts_going_toward(ploy.will_go_to[0])
	ploy.dialog = [
		"Ploy: Cool, right?",
		"Ploy: My grandmother taught me this Spell during my initiation.",
		"Ploy: Oh by the way I just saw Pet! This guy is always such a jerk!",
		"Ploy: Anyways. Follow me!",
	]
	ploy.post_dialog_event = ["ploy_goes_towards_her_house", ploy]
	
	var timer = Timer.new()
	timer.connect("timeout", self, "destroy_bush")
	timer.set_wait_time(2)
	timer.set_one_shot(true)
	timer.autostart = true
	timer.start()
	add_child(timer)

func destroy_bush():
	bush.queue_free()

func ceremony_special_effect(_parameters):
#	Game.current_scene.
	pass

func execute(event_id, parameters):
	call(event_id, parameters)
