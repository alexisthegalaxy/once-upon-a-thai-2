extends Node2D

var mode_is_explore = true
var on_mode_switch = false  # indicates that the cursor is on the button on_mode_switch
var has_desired_zoom = true
var desired_zoom = Vector2(1, 1)
var lo = TranslationServer.get_locale()
var following_word = null # {
#		"id": 400,
#		"over_word": null,  # this is the sphere itself, following the player
#	}
func _ready():
	Game.palace = self
	Game.current_scene = self
	SoundPlayer.crossfade_to("res://Sounds/FLOATLANDS_ORIGINAL_SOUNDTRACK/Wandering.wav", 0.0)
	switch_to_explore()
	if Game.following_words:
		Game.gains_focus(self)


func dialog_option(_dialog, response):
	var YES = 1  # NO = 2
	if response == YES:
		place_down_word()
	else:
		Game.gains_focus(self)

func place_down_word():
	var new_word = load("res://Lexical/Word/Spell.tscn").instance()
	new_word.id = following_word.id
	new_word.word = Game.words[str(following_word.id)]
	new_word.can_move = false
	new_word.position = Game.player.position
	Game.following_words = []
	Game.lose_focus(self)
	following_word.over_word.queue_free()
	following_word = null
	call_deferred("add_word", new_word)

func add_word(new_word):
	Game.current_scene.get_node("YSort").add_child(new_word)

func interact():
	"""
	The player can interact anywhere in the Palace if there is a following Word.
	Upon interaction, a dialog box asks whether to place down the Word here.
	"""
	if not Game.following_words:
		return
	following_word = Game.following_words[0]
	var word = Game.words[str(following_word.id)]
	var dialog = tr("_do_you_to_place_word_here").replace("[Word]", word.th + " (" + word[lo] + ")")
	get_tree().set_input_as_handled()
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog([dialog], self, null, false, null)
	Game.current_scene.add_child(Game.current_dialog)

func _process(delta):
	if not has_desired_zoom:
		var current_zoom = $YSort/Player/Camera2D.zoom
		if current_zoom.distance_squared_to(desired_zoom) < 0.001:
			$YSort/Player/Camera2D.zoom = desired_zoom
		else:
			$YSort/Player/Camera2D.zoom = ((4 + delta) * current_zoom + desired_zoom) / (5 + delta)

func ui_cancel():
	if not $EditorObjectOnCursor.is_visible():
		Game.show_exit_screen()
	$EditorObjectOnCursor.ui_cancel()

func close():
	ChangeMap.call_deferred(
		"_deferred_goto_scene",
		Game.player_last_overworld_map_visited,
		Game.player_position_on_overworld.x,
		Game.player_position_on_overworld.y,
		0
	)
	queue_free()
	Game.palace = null

func _input(_event):
	if _event.is_action_pressed("tab"):
		_on_ModeSwitch_pressed()
		
func _on_ModeSwitch_pressed():
	if mode_is_explore:
		switch_to_enhance()
	else:
		switch_to_explore()

func switch_to_enhance():
	mode_is_explore = false
	Game.player.stop_walking()
	$Control/ModeSwitch.text = tr('_explore_palace')
	$Control.show()
	$YSort/Player/Light2D.hide()
	desired_zoom = Vector2(2, 2)
	has_desired_zoom = false
	$YSort/Player.modulate = Color(1, 1, 1, 0.1)
	Game.main_ui.hide()
	Game.player.can_interact = false

func switch_to_explore():
	mode_is_explore = true
	$Control/ModeSwitch.text = tr('_enhance_palace')
	$Control.hide()
	$YSort/Player/Light2D.show()
	desired_zoom = Vector2(1, 1)
	has_desired_zoom = false
	$YSort/Player.modulate = Color(1, 1, 1, 1)
	Game.main_ui.update_main_ui()
	Game.player.can_interact = true
	$EditorObjectOnCursor.ui_cancel()

func _on_ModeSwitch_mouse_entered():
	on_mode_switch = true
	$EditorObjectOnCursor.can_place = false
	$EditorObjectOnCursor.hide()

func _on_ModeSwitch_mouse_exited():
	on_mode_switch = false
	$EditorObjectOnCursor.can_place = true
	if $EditorObjectOnCursor.current_item or $EditorObjectOnCursor.current_tileset:
		$EditorObjectOnCursor.show()
