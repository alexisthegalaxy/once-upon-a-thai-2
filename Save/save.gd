extends Node


func save_game():
	# When called, this function saves the data into a file, with the player's name
	# Can be reused on next log-in.
	# This is used when starting or ending a session, and whenever we want to save progress.
	var save_data = {
		"current_map": Game.current_map_name
	}
	var save_file = File.new()
	save_file.open("user://%s.save" % Game.player_name, File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
	print('has saved game')

func load_game(player_name):
	var save_file = File.new()
	var save_file_path = "user://%s.save" % player_name
	if not save_file.file_exists(save_file_path):
		print("Couldn't find savefile with name: ", save_file_path)
		return
	save_file.open(save_file_path, File.READ)
	var save_data = parse_json(save_file.get_line())
	print(save_data)
	save_file.close()
	
func provisory_save():
	# Some data (for example, what word is in what source) is saved here.
	# on each map change, we save the data,
	# and then update the map we're going to using the provisory_load.
	# This is independant but similar to the main save.
	pass
