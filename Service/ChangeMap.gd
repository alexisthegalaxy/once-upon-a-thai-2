extends Node

func move_player(to_x, to_y, level_y_height_change):
	var player_velocity = Vector2.ZERO
	if Game.player:
		player_velocity = Game.player.velocity
		
	Game.player = Game.current_scene.get_node("YSort/Player")
	Game.player.position = Vector2(to_x, to_y)
	Game.player.velocity = player_velocity
	
	Game.player.get_node("Sprite").position.y -= level_y_height_change
	Game.player.get_node("Camera2D").position.y -= level_y_height_change
	Game.player.get_node("Shadow").position.y -= level_y_height_change
	Game.player.get_node("CollisionShape2D").position.y -= level_y_height_change
	Game.player.position.y += level_y_height_change

func free_all_non_necessary_nodes():
	for child in get_tree().get_root().get_children():
		if not child.get_name() in [
			"Game",
			"Events",
			"SoundPlayer",
			"DistractorsHelper",
			"Save",
			"Quests",
			"Money",
			"ChangeMap",
			"ShowLocationName"
		]:
			child.queue_free()

func update_main_ui_upon_map_change():
	if not Game.main_ui:
		Game.main_ui = load("res://UI/MainUI.tscn").instance()
	Game.main_ui.update_main_ui()
	Game.add_child(Game.main_ui)

func save_following_words_data_before_map_change():
	return

func generate_following_words_after_map_change():
	for following_word in Game.following_words:
		var new_spell = load("res://Lexical/Word/Spell.tscn").instance()
		new_spell.id = following_word.id
		new_spell.word = Game.words[str(following_word.id)]
		new_spell.can_move = true
		new_spell.position = Game.player.position
		new_spell.set_as_following()
		Game.current_scene.get_node("YSort").add_child(new_spell)
		following_word.over_word = new_spell

func set_sources_after_map_change():
	for source in Game.sources:
		var split_name = source.split("|")
		var source_map_name = split_name[0]
		var source_name = split_name[1]
		if source_map_name == Game.current_map_name:
#			var source_node = Game.current_scene.get_node("YSort").get_node("Sources").get_node(source_name)
			var source_node = Game.current_scene.get_node("YSort/Sources").get_node(source_name)
			source_node.word_ids = Game.sources[source]
			source_node.update_source(true)

func _deferred_goto_scene(to_map_name, to_x, to_y, level_y_height_change):
	if Game.canvas_color_screen:
		Game.canvas_color_screen.queue_free()
		Game.canvas_color_screen = null
	save_following_words_data_before_map_change()
	Game.is_frozen = false
	if Game.player:
		Game.player_position_on_overworld = Game.player.position
		Game.player_last_overworld_map_visited = Game.current_map_name
	var previous_map_name = Game.current_map_name
	Game.current_map_name = to_map_name
	
	
	if Game.current_scene:
		Game.current_scene.queue_free()
	
	assert(to_map_name != "")
	Game.current_scene = ResourceLoader.load(to_map_name).instance()
	Game.main_ui.hovered_buttons = []

	move_player(to_x, to_y, level_y_height_change)
	
	SoundPlayer.start_music_upon_entering_map(to_map_name)
	free_all_non_necessary_nodes()
	get_tree().get_root().add_child(Game.current_scene)
	
	generate_following_words_after_map_change()
	set_sources_after_map_change()
	update_main_ui_upon_map_change()
