extends Node

func move_player(to_x, to_y, level_y_height_change):
	var player_velocity = Vector2.ZERO
	if Game.player:
		player_velocity = Game.player.velocity
		
	Game.player = Game.current_scene.get_node("YSort").get_node("Player")
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
			"ChangeMap"
		]:
			child.queue_free()

func update_main_ui_upon_map_change():
	if not Game.main_ui:
		Game.main_ui = load("res://UI/MainUI.tscn").instance()
	Game.main_ui.update_main_ui()
	Game.add_child(Game.main_ui)

func save_following_spells_data_before_map_change():
	for following_spell in Game.following_spells:
		following_spell.time_to_live = following_spell.over_word.time_to_live

func generate_following_spells_after_map_change():
	for following_spell in Game.following_spells:
		var new_spell = load("res://Lexical/Word/Spell.tscn").instance()
		new_spell.id = following_spell.id
		new_spell.word = Game.words[str(following_spell.id)]
		new_spell.can_move = true
		new_spell.position = Game.player.position
		new_spell.set_as_following()
		Game.current_scene.get_node("YSort").add_child(new_spell)
		following_spell.over_word = new_spell
		following_spell.over_word.time_to_live = following_spell.time_to_live

func set_sources_after_map_change():
	for source in Game.sources:
		var split_name = source.split("|")
		var source_map_name = split_name[0]
		var source_name = split_name[1]
		if source_map_name == Game.current_map_name:
			var source_node = Game.current_scene.get_node("YSort").get_node("Sources").get_node(source_name)
			source_node.word_ids = Game.sources[source]
			source_node.update_source(true)

func update_letters_to_look_for_if_necesssary(_to_map_name):
	if not Events.events["can_see_the_looking_for_letter_banner"]:
		return
	if not Events.events["has_been_in_the_letter_world"]:
		return
	Game.player.arrow.arrow_letter_update()
	Game.looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
	var letters_we_look_for_here = []
	if Game.this_letter_world_has_letters:
		for letter_id in Game.this_letter_world_has_letters:
			var letter = Game.letters[str(letter_id)]
			if letter in Game.letters_we_look_for:
				letters_we_look_for_here.append(letter)
	else:
		letters_we_look_for_here = Game.letters_we_look_for
	Game.looking_for_letter__node.init_letters_we_look_for(letters_we_look_for_here)
	Game.current_scene.add_child(Game.looking_for_letter__node)

func start_test_when_back_from_MP():
	if Game.should_start_test_when_back_from_MP[0]:
		var word_id = Game.should_start_test_when_back_from_MP[1]
		var new_word = load("res://Lexical/Word/Spell.tscn").instance()
		new_word.id = word_id
		new_word.word = Game.words[str(word_id)]
		new_word.can_move = true
		new_word.position = Game.player.position
		Game.current_scene.get_node("YSort").add_child(new_word)
		Game.start_test(
			Game.should_start_test_when_back_from_MP[0],
			word_id,
			new_word
		)

func _deferred_goto_scene(to_map_name, to_x, to_y, level_y_height_change):
	if Game.canvas_color_screen:
		Game.canvas_color_screen.queue_free()
		Game.canvas_color_screen = null
	save_following_spells_data_before_map_change()
	Game.is_frozen = false
	if not Game.is_in_letter_world():
		if Game.player:
			Game.player_position_on_overworld = Game.player.position
			Game.player_last_overworld_map_visited = Game.current_map_name
	var previous_map_name = Game.current_map_name
	Game.current_map_name = to_map_name
	
	if Game.current_scene:
		Game.current_scene.queue_free()
	
	assert(to_map_name != "")
	Game.current_scene = ResourceLoader.load(to_map_name).instance()

	move_player(to_x, to_y, level_y_height_change)
	
	SoundPlayer.start_music_upon_entering_map(to_map_name)
	free_all_non_necessary_nodes()
	get_tree().get_root().add_child(Game.current_scene)
	
	generate_following_spells_after_map_change()
	set_sources_after_map_change()
	update_main_ui_upon_map_change()
	if "LexicalWorld" in to_map_name:
		update_letters_to_look_for_if_necesssary(Game.to_map_name)
		for following_spell in Game.following_spells:
			following_spell.over_word.hide()

	if "LexicalWorld" in previous_map_name and not "LexicalWorld" in Game.current_map_name:
		# Coming back to Material world
		Game.current_scene.get_node("Lights").get_node("CanvasModulate").color = Game.last_goal_color
		start_test_when_back_from_MP()
		for following_spell in Game.following_spells:
			following_spell.over_word.show()
