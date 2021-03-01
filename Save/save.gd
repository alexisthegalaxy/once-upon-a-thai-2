extends Node


func save_game():
	# When called, this function saves the data into a file, with the player's name
	# to be reused on next log-in.
	# This is to be used when starting or ending a session,
	# and whenever we click the save button to save progress.
	var save_data = {
		"current_map": Game.current_map_name,
		"player_data": Game.player.save_game(),
		"game_data": Game.save_game(),
		"quests_data": Quests.save_game(),
		"events_data": Events.save_game(),
	}
	var save_file = File.new()
	save_file.open("user://%s.save" % Game.player_name, File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()

func apply_change_from_save_data(save_data):
	# 1 - map change
	ChangeMap._deferred_goto_scene(save_data.current_map, 0, 0, 0)
	# 2 - player changes
	Game.player.load_game(save_data.player_data)
	# 3 - game, vocabulary, sources
	Game.load_game(save_data.game_data)
	ChangeMap.generate_following_spells_after_map_change()
	# 4 - quests
	Quests.load_game(save_data.quests_data)
	# 5 - Events
	Events.load_game(save_data.events_data)

func load_game(player_name):
	var save_file = File.new()
	var save_file_path = "user://%s.save" % player_name
	if not save_file.file_exists(save_file_path):
		print("Couldn't find savefile with name: ", save_file_path)
		return
	save_file.open(save_file_path, File.READ)
	var save_data = parse_json(save_file.get_line())
	print("loading:")
	print(save_data)
	save_file.close()
	apply_change_from_save_data(save_data)
	Game.main_ui.update_main_ui()
	
func provisory_save():
	# Some data (for example, what word is in what source) is saved here.
	# on each map change, we save the data,
	# and then update the map we're going to using the provisory_load.
	# This is independant but similar to the main save.
	pass
