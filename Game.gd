extends Node

var change_color = false
var last_goal_color = Color(1, 1, 1, 1)
var goal_color = null

var words = []
var sentences = []
var letters = []

# The following are a list of IDs
#var known_words = [343, 345, 207, 82] 
var known_words = [82]
#var known_sentences = [196, 197, 198, 199]  # we know the translation. Does not contain seen_sentences.
#var known_sentences = [196, 197, 198]  # we know the translation. Does not contain seen_sentences.
var known_sentences = [200, 201]  # we know the translation. Does not contain seen_sentences.
var seen_sentences = [196, 197, 198, 199]  # we don't know the translation
#var known_letters = [0, 11, 13, 21]  # list of IDs
#var known_letters = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40]  # list of IDs
var known_letters = []  # list of IDs
#var known_letters = [0, 11, 13, 21, 28]  # five letters
var collected_letters = []
var following_spells = []
#var following_spells = [
#	{
#		"id": 400,
#		"over_word": null,
#		"time_to_live": 2.3  # the time_to_live is saved before the map change
#	}
#]

# This indicates only the modifications, not the default state.
# The source of truth is the scene
var sources = {
#	"res://Maps/Chaiyaphum.tscn|EmptySourceBehindWat": [0],
}

var exit_screen = false
var current_dialog = null

var this_letter_world_has_letters = []  # a list of letter ids
var letters_we_look_for = []  # a list of letters
var looking_for_letter__node = null
var player_position_on_overworld = Vector2(1183, 167)  # used when coming back from Letter World
var player_last_overworld_map_visited = "res://Maps/Chaiyaphum.tscn"
var current_map_name = "res://Maps/Chaiyaphum.tscn"

# This is the letters yaai asks us to fetch the first time we come in the Memory Palace
#var initial_letters = [0, 6, 9, 11, 13, 17, 19, 21, 28, 36]  # outdated
var initial_letters = [11, 13, 28, 0, 21]

# when players comes near a npc/word/letter/sentence,
# it get appended to current_focus, and gets removed when leaving
var current_focus = []
var space_bar_to_interact = null
var current_scene = null
var active_test = null
var player = null
var player_name = "Alexis"
var player_sprite_path = "res://Npcs/sprites/main_E.png"
var can_read_thai = false

var hp = 5.0
var max_hp = 5.0
var rng = RandomNumberGenerator.new()
var is_frozen = false

var should_start_test_when_back_from_MP = [
	null,  # "res://Test/TestGuessMeaning.tscn"
	null,  # word_id
]

var deducing_coop_select_sentence_screen = null
var select_follower_to_implant_screen = null
var canvas_color_screen = null

func blackens():
	canvas_color_screen = ColorRect.new()
	canvas_color_screen.set_position(Vector2(-10000, -10000))
	canvas_color_screen.set_size(Vector2(100000, 100000))
	canvas_color_screen.color = Color(0, 0, 0, 0)
	get_tree().get_root().add_child(canvas_color_screen)

func is_overworld_frozen():
	return (
		active_test or
		current_dialog or
		is_frozen or
		select_follower_to_implant_screen or
		(player and (
			player.hub or
			player.dict or
			player.alphabet or
			player.notebook or
			player.word_page or
			player.letter_page
		))
	)

func set_sources_after_map_change():
	for source in sources:
		var split_name = source.split("|")
		var source_map_name = split_name[0]
		var source_name = split_name[1]
		if source_map_name == current_map_name:
			var source_node = Game.current_scene.get_node("YSort").get_node("Sources").get_node(source_name)
			source_node.word_ids = sources[source]
			source_node.update_source(true)

func generate_following_spells_after_map_change():
	for following_spell in following_spells:
		print('following_spell', following_spell)
		var new_spell = load("res://Lexical/Word/Spell.tscn").instance()
		new_spell.id = following_spell.id
		new_spell.word = Game.words[str(following_spell.id)]
		new_spell.can_move = true
		new_spell.position = player.position
		new_spell.set_as_following()
		current_scene.get_node("YSort").add_child(new_spell)
		following_spell.over_word = new_spell
		following_spell.over_word.time_to_live = following_spell.time_to_live

func save_following_spells_data_before_map_change():
	for following_spell in following_spells:
		print('following_spell ', following_spell)
		following_spell.time_to_live = following_spell.over_word.time_to_live
	

func add_following_spell(word_id, over_word):
	over_word.set_as_following()
	following_spells.append({
		"id": word_id,
		"over_word": over_word,
		"time_to_live": over_word.time_to_live,
	})

func update_following_spells_ime_to_live():
	for following_spell in following_spells:
		following_spell.time_to_live = following_spell.over_word.time_to_live

func dialog_press_f_to_see_it(learnt_item):
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	var lines = []
	if learnt_item == "sentence":
		lines = [tr("_press_f_to_open_your_notebook_and_see_your_sentences")]
	if learnt_item == "letter":
		lines = [tr("_press_f_to_open_your_alphabet_and_see_your_letters")]
	if learnt_item == "word":
		lines = [tr("_press_f_to_open_your_dictionary_and_see_that_word")]
	Game.current_dialog.init_dialog(lines, null, null, null, null)
	current_scene.add_child(Game.current_dialog)

func a_word_is_learnt():
	pass
	# Whenever a word is learnt, we run this function
#	if len(Game.known_words) == 10:
#		Game.pop_victory_screen()
#	if not Events.events.has_learnt_four_first_words:
#		if 343 in Game.known_words and 345 in Game.known_words and 207 in Game.known_words and 82 in Game.known_words:
#			Events.events.has_learnt_four_first_words = true
#			if not Game.current_focus:
#				Game.current_focus.append(Game.current_scene.get_node("YSort").get_node("NPCs").get_node("Yaai"))
#			Events.npc_walks_to([[player.position]])

func discovers_sentence(sentence_id, is_translated):
	Game.is_frozen = true
	Game.lose_focus(null)
	var sentence_discovery = load("res://Lexical/Sentence/SentenceDiscovery.tscn").instance()
	sentence_discovery.sentence_discovery_init(sentence_id, is_translated)
	current_scene.add_child(sentence_discovery)

func starts_deducing_coop():
	Game.is_frozen = true
	Game.lose_focus(null)
	var deducing_coop_selection_screen = load("res://Test/DeducingCoop/DeducingCoopSelectSentence.tscn").instance()
	current_scene.add_child(deducing_coop_selection_screen)

func clear_deleted_focuses():
	for object in current_focus:
		if not is_instance_valid(object):
			current_focus.erase(object)

func gains_focus(target):
	clear_deleted_focuses()
	# When the player enters into the interat zone of npc/word/letter
	if not space_bar_to_interact:
		space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
		current_scene.add_child(space_bar_to_interact)
	current_focus.append(target)

func reset_focus():
	clear_deleted_focuses()
	if current_focus:
		if not space_bar_to_interact:
			space_bar_to_interact = load("res://UI/SpaceBarToInteract.tscn").instance()
			Game.current_scene.add_child(space_bar_to_interact)

func lose_focus(target):
	clear_deleted_focuses()
	if not target:
		current_focus = []
	while target in current_focus:
		current_focus.erase(target)
	if not current_focus:
		if space_bar_to_interact:
			space_bar_to_interact.queue_free()
			space_bar_to_interact = null

func learn_letter(letter):
	Game.known_letters.append(letter["id"])
	if looking_for_letter__node:
		looking_for_letter__node.update_label_text()
	Game.player.arrow.arrow_letter_update()
	var knows_the_letters_from_the_beginning = true
	for letter_id_from_the_beginning in initial_letters:
		if not letter_id_from_the_beginning in known_letters:
			knows_the_letters_from_the_beginning = false
	if not Events.events["has_finished_the_letter_world_the_first_time"] and knows_the_letters_from_the_beginning:
		Events.events["has_finished_the_letter_world_the_first_time"] = true
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		var dialog = [
			tr("_name_exclamation_mark"),
			tr("_name_do_you_hear_me"),
			tr("_you_have_found_all_the_needed_letters_for_now"),
			tr("_to_leave_this_world_press_f_key"),
		]
		Game.current_dialog.init_dialog(dialog, null, null, false, "Yaai")
		player.stop_walking()
		Game.current_scene.add_child(Game.current_dialog)

func add_random_letter_to_letters_to_look_for():
	var random_letter = Game.letters[str(rng.randi() % Game.letters.size())]
	if not random_letter in letters_we_look_for:
		letters_we_look_for.append(random_letter)
		if looking_for_letter__node:
			looking_for_letter__node.init(letters_we_look_for)
		else:
			looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
			looking_for_letter__node.init(letters_we_look_for)
			Game.current_scene.add_child(looking_for_letter__node)

func set_hp(_hp) -> void:
	player.set_hp(_hp)

func knows_word(word) -> bool:
	return word["id"] in known_words

func knows_letter(letter) -> bool:
	return letter["id"] in known_letters

func print_known_sentences() -> void:
	print('print_known_sentences')
	for known_sentence_id in known_sentences:
		var sentence = sentences[str(known_sentence_id)]
		print(sentence["th"])
	print('print_seen_sentences')
	for seen_sentence_id in seen_sentences:
		var sentence = sentences[str(seen_sentence_id)]
		print(sentence["th"])
	print("\n")

func pop_victory_screen() -> void:
	var VictoryScreen = load("res://UI/Victory.tscn")
	var victory_screen = VictoryScreen.instance()
	var world = current_scene
	world.add_child(victory_screen)

func retrieve_from_json_file(file):
	var data_file = File.new()
	if data_file.open(file, File.READ) != OK:
		print('problem opening the json file!!!')
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		print('problem parsing the json file!!!')
		return
	return data_parse.result

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	words = retrieve_from_json_file("res://Lexical/Word/words.json")
	sentences = retrieve_from_json_file("res://Lexical/Sentence/sentences.json")
	letters = retrieve_from_json_file("res://Lexical/Letter/letters.json")
	for word_id in words:
		words[word_id]["id"] = int(word_id)
		if not "fr" in words[word_id]:
			words[word_id].fr = words[word_id].en
	for sentence_id in sentences:
		sentences[sentence_id]["id"] = int(sentence_id)
		if not "fr" in sentences[sentence_id]:
			sentences[sentence_id].fr = sentences[sentence_id].en
	for letter_id in letters:
		letters[letter_id]["id"] = int(letter_id)
		if not "fr" in letters[letter_id]:
			letters[letter_id].fr = letters[letter_id].en

func _input(_event):
	if _event.is_action_pressed("ui_cancel"):
		if not exit_screen:
			exit_screen = load("res://UI/ExitAreYouSure.tscn").instance()
#			get_tree().current_scene.add_child(exit_screen)
			Game.current_scene.add_child(exit_screen)
		else:
			if is_instance_valid(exit_screen):
				exit_screen.stay()

func _process(delta):
	OS.set_window_title("Once upon a Thai | fps: " + str(Engine.get_frames_per_second()))
	if change_color:
		var canvas_modulate = current_scene.get_node("Lights").get_node("CanvasModulate")
		var direction = Vector3(goal_color.r, goal_color.g, goal_color.b) - Vector3(canvas_modulate.color.r, canvas_modulate.color.g, canvas_modulate.color.b)
		if direction.length() < 0.0001:
			change_color = false
		canvas_modulate.color.r += delta * direction.x
		canvas_modulate.color.g += delta * direction.y
		canvas_modulate.color.b += delta * direction.z
	if canvas_color_screen:
		canvas_color_screen.color.a = min(1, canvas_color_screen.color.a + delta)

func update_letters_to_look_for_if_necesssary(to_map_name):
	if not Events.events["can_see_the_looking_for_letter_banner"]:
		return
	if not Events.events["has_been_in_the_letter_world"]:
		return
	Game.player.arrow.arrow_letter_update()
	looking_for_letter__node = load("res://Lexical/Alphabet/LookingForLetters.tscn").instance()
	
	var letters_we_look_for_here = []
	if this_letter_world_has_letters:
		for letter_id in this_letter_world_has_letters:
			var letter = letters[str(letter_id)]
			if letter in letters_we_look_for:
				letters_we_look_for_here.append(letter)
	else:
		letters_we_look_for_here = letters_we_look_for
	looking_for_letter__node.init(letters_we_look_for_here)
	current_scene.add_child(looking_for_letter__node)

func start_test_when_back_from_MP():
	if should_start_test_when_back_from_MP[0]:
		var word_id = should_start_test_when_back_from_MP[1]
		print('Game should_start_test_when_back_from_MP', should_start_test_when_back_from_MP)
		var new_word = load("res://Lexical/Word/Spell.tscn").instance()
		new_word.id = word_id
		new_word.word = Game.words[str(word_id)]
		new_word.can_move = true
		new_word.position = player.position
		print('current_scene', current_scene)
		current_scene.get_node("YSort").add_child(new_word)
		start_test(
			should_start_test_when_back_from_MP[0],
			word_id,
			new_word
		)

#func _clear_non_singletons():
	# TODO: Use it in _deferred_goto_scene before we set a new child
#	for child in get_tree().get_root().get_children():
#		print('--- child name ', child.get_name())
#		if not child.get_name() in ["Game", "Events", "SoundPlayer"]:
#			child.queue_free()

func _deferred_goto_scene(to_map_name, to_x, to_y, level_y_height_change):
	if canvas_color_screen:
		canvas_color_screen.queue_free()
		canvas_color_screen = null
	save_following_spells_data_before_map_change()
	is_frozen = false
	if not "LexicalWorld" in current_map_name:
		if player:
			player_position_on_overworld = player.position
			player_last_overworld_map_visited = current_map_name
	var previous_map_name = current_map_name
	current_map_name = to_map_name
	
	var player_velocity = Vector2.ZERO
	if player:
		player_velocity = player.velocity
	
	if current_scene:
		current_scene.queue_free()
	
	assert(to_map_name != "")
	current_scene = ResourceLoader.load(to_map_name).instance()
#	print('current_scene', current_scene.get_children())
#	if len(current_scene.get_children()) == 3:
#		SoundPlayer.play_thai("ตุ๊กแก")
#		yield(get_tree().create_timer(1.0), "timeout")
	
#	var b = current_scene.get_node("YSort")
#	SoundPlayer.play_thai("คน")
#	yield(get_tree().create_timer(1.0), "timeout")
#	var children = b.get_children()  # crash only on production!
	
#	SoundPlayer.play_thai("คน")
#	yield(get_tree().create_timer(1.0), "timeout")
	
	# Problem here!!!!
	# It looks like it fails to find .get_node("Player")
	# inside current_scene.get_node("YSort")!
#	var c = current_scene.get_node("YSort").get_node("Player")
	
	player = current_scene.get_node("YSort").get_node("Player")
	player.position = Vector2(to_x, to_y)
	player.velocity = player_velocity
	
	player.get_node("Sprite").position.y -= level_y_height_change
	player.get_node("Camera2D").position.y -= level_y_height_change
	player.get_node("Shadow").position.y -= level_y_height_change
	player.get_node("CollisionShape2D").position.y -= level_y_height_change
	player.position.y += level_y_height_change
	
	
	SoundPlayer.start_music_upon_entering_map(to_map_name)

	# If we add a yield(get_tree().create_timer(1.0), "timeout")
	# between the next two lines, we get a crash. Why?
	for child in get_tree().get_root().get_children():
		if not child.get_name() in [
			"Game",
			"Events",
			"SoundPlayer",
			"DistractorsHelper",
			"Save",
			"Quests"
		]:
			child.queue_free()
	get_tree().get_root().add_child(current_scene)
	
#	for child in get_tree().get_root().get_children():
#		print('--- child name ', child.get_name())
#		if child.get_name() == "PlayerHouse":
#			SoundPlayer.play_thai("เป็น")
#			yield(get_tree().create_timer(1.0), "timeout")
#	print('get_tree().get_root().get_children()', get_tree().get_root().get_children())  # ViewPort
#	get_tree().set_current_scene(current_scene)

	generate_following_spells_after_map_change()
	set_sources_after_map_change()
	if "LexicalWorld" in to_map_name:
		update_letters_to_look_for_if_necesssary(to_map_name)
		for following_spell in following_spells:
			following_spell.over_word.hide()

	if "LexicalWorld" in previous_map_name and not "LexicalWorld" in current_map_name:
		# Coming back to Material world
		current_scene.get_node("Lights").get_node("CanvasModulate").color = Game.last_goal_color
		start_test_when_back_from_MP()
		for following_spell in following_spells:
			following_spell.over_word.show()
	
#	SoundPlayer.play_thai("ดี")
#	yield(get_tree().create_timer(1.0), "timeout")
	
func _on_InteractBox_body_entered(_player, npc) -> void:
	_player._on_InteractBox_body_entered(npc)

func _on_InteractBox_body_exited(_player, npc) -> void:
	_player._on_InteractBox_body_exited(npc)

func add_sentence(sentence_id, x, y):
	known_sentences.append(sentence_id)
	var floaty = load("res://UI/Floaty.tscn").instance()
	floaty.text = "new sentence added!"
	floaty.position.x = x
	floaty.position.y = y
	current_scene.add_child(floaty)

func _on_sentence_area_entered(sentence_id, x, y) -> void:
	if not sentence_id in known_sentences:
		add_sentence(sentence_id, x, y)

func _on_changelight_entered(color) -> void:
	change_color = true
	goal_color = color
	last_goal_color = color

func start_test(test_scene, entity_id, over_entity) -> void:
	"""
	entity either refers to a letter or to a word
	(maybe to a phrase too, later on?)
	"""
	var test = load(test_scene).instance()
	self.add_child(test)
	active_test = test
	test.init(entity_id, over_entity)
	if looking_for_letter__node:
		looking_for_letter__node.get_node("Node2D").hide()

func save_game():
	var game_data = {}
	game_data.change_color = change_color
	game_data.last_goal_color = last_goal_color
	game_data.goal_color = goal_color
	game_data.known_words = known_words
	game_data.known_sentences = known_sentences
	game_data.seen_sentences = seen_sentences
	game_data.known_letters = known_letters
	game_data.collected_letters = collected_letters
	game_data.following_spells = following_spells
	print('game_data.following_spells', game_data.following_spells)
	game_data.this_letter_world_has_letters = this_letter_world_has_letters
	game_data.letters_we_look_for = letters_we_look_for
	game_data.this_letter_world_has_letters = this_letter_world_has_letters
	game_data.player_position_on_overworld = player_position_on_overworld
	game_data.player_last_overworld_map_visited = player_last_overworld_map_visited
	game_data.can_read_thai = can_read_thai
	game_data.should_start_test_when_back_from_MP = should_start_test_when_back_from_MP
	game_data.sources = sources
	return game_data

func load_game(game_data):
	change_color = game_data.change_color
	last_goal_color = game_data.last_goal_color
	goal_color = game_data.goal_color
	known_words = game_data.known_words
	known_sentences = game_data.known_sentences
	seen_sentences = game_data.seen_sentences
	known_letters = game_data.known_letters
	collected_letters = game_data.collected_letters
	update_following_spells_ime_to_live()
	following_spells = game_data.following_spells
	this_letter_world_has_letters = game_data.this_letter_world_has_letters
	letters_we_look_for = game_data.letters_we_look_for
	this_letter_world_has_letters = game_data.this_letter_world_has_letters
	player_position_on_overworld = game_data.player_position_on_overworld
	player_last_overworld_map_visited = game_data.player_last_overworld_map_visited
	can_read_thai = game_data.can_read_thai
	should_start_test_when_back_from_MP = game_data.should_start_test_when_back_from_MP
	sources = game_data.sources
