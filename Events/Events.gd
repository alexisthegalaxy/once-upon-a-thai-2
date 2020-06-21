extends Node

func event_1(parameters):
	var v0 = parameters[0]
	var v1 = parameters[1]
	
	print('Un ', v0, ' ', v1, '!')

func npc_walks_to(parameters):
	var target_positions = parameters[0]
	print('target_positions')
	print(target_positions)
	Game.current_focus.will_go_to = target_positions
	if target_positions:
		Game.current_focus.starts_going_toward(target_positions[0])
	else:
		print('nowhere to go!')

func execute(event_id, parameters):
	call(event_id, parameters)
