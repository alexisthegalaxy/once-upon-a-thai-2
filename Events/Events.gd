extends Node

var events = {
	"yaai_explains_rock": false,
	"ceremony_finished": false,
	"has_finished_the_letter_world_the_first_time": false,
	"has_been_in_the_letter_world": false,
	"ceremony_started": false,
	"yaai_went_to_forest_entrance": false,
	"talked_to_yaai_for_the_first_time": false,
	"talked_to_nim_at_the_beginning": false,
}

func lose_focus(_parameters):
	for focus in Game.current_focus:
		Game.loses_focus(focus)

func show_looking_for_letters(_parameters):
	Game.looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
	Game.looking_for_letter__node.init(Game.letters_we_look_for)
	get_tree().current_scene.add_child(Game.looking_for_letter__node)
	get_tree().current_scene.get_node("YSort").get_node("Door Vowels").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door Accents").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door MC").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door HC").init_letters()
	get_tree().current_scene.get_node("YSort").get_node("Door LC").init_letters()
	Events.events["has_been_in_the_letter_world"] = true
	
func nim_walks_to(parameters):
	events["talked_to_nim_at_the_beginning"] = true
	Game.current_focus[0].dialog = ["Nim: Granny is waiting for you outside.", "Nim: Be brave, okay?"]
	npc_walks_to(parameters)
	
func yaai_walks_to(parameters):
	events["talked_to_yaai_for_the_first_time"] = true
	npc_walks_to(parameters)
#	var target_positions = parameters[0]
#	Game.current_focus.will_go_to = target_positions
#	if target_positions:
#		Game.current_focus.starts_going_toward(target_positions[0])
#	else:
#		print('nowhere to go!')

func npc_walks_to(parameters):
	var target_positions = parameters[0]
#	print('target_positions')
#	print(target_positions)
	Game.current_focus[0].will_go_to = target_positions
	if target_positions:
		Game.current_focus[0].starts_going_toward(target_positions[0])
	else:
		print('nowhere to go!')

func learns_first_sentence(calling_npc):
	Game.loses_focus(Game.current_focus)
	Game.discovers_sentence(196, true)
	calling_npc.dialog = ["Yaai: Well done [Name]! Now, go deeper in the forest."]
	calling_npc.post_dialog_event = []

func immediately_enters_lexical_world():
	Game.call_deferred("_deferred_goto_scene", "res://Maps/LexicalWorld/LetterHub.tscn", 13, 71.66)

func enters_lexical_world(_parameters):
	get_tree().current_scene.blackens()
	var timer = Timer.new()
	Game.can_move = false
	timer.connect("timeout", self, "immediately_enters_lexical_world")
	timer.set_wait_time(1)
	timer.set_one_shot(true)
	timer.autostart = true
	timer.start()
	add_child(timer)

#	var target_positions = [
#		Vector2(266.69, 528.84),
#		Vector2(273.62, 623.76),
#		Vector2(226.68, 635.33),
#	]
#	Game.current_focus.will_go_to = target_positions
#	if target_positions:
#		Game.current_focus.starts_going_toward(target_positions[0])

func ceremony_special_effect(_parameters):
#	Game.current_scene.
	pass

func execute(event_id, parameters):
	call(event_id, parameters)
