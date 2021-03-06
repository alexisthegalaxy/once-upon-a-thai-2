extends StaticBody2D

export(Array, String) var dialog = []
export var sprite_path = "res://Npcs/sprites/yaai.png"
export var direction = "down"
export var wanders = 0  # the range of wandering from the initial direction
export var state = "stand"  # can be "stand" or "walk"
export var display_name = ""  # Is shown in dialogs. For example: "Nim".
export var interact_when_near = false
var temporarily_interact_when_near = false  # used when pokewalking
export(Array, String) var start_quests = []  # ["find_sentences_in_chaiyaphum", "first_quest"]
export(Array, String) var finish_quests = []  # ["find_sentences_in_chaiyaphum", "first_quest"]
export(String) var interaction_sentence_id = ""
var want_to_check_if_can_move_towards_position = false

var is_talking = false
var initial_position  # used for wandering npcs
var speed = 100  # 65
var velocity = Vector2.ZERO
var is_walking_towards = null
var will_go_to = []  # array of vector2 positions

var will_pokecome = false  # true if this NPC wants to come (even before meeting its gaze)

# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

export(Array, String) var sold_entities = []

var time = 0
var over_head_label_y

# white orb disappearance - should be in its own node
var white_orb_growing = false
var white_orb_fading = false
var alpha = 1


func update_npc_overhead():
	if finish_quests:
		for finish_quest_id in finish_quests:
			if Quests.quests[finish_quest_id].status == Quests.FINISHED:
				$OverheadNode2D.visible = true
				$OverheadNode2D/blue_smile.visible = false
				$OverheadNode2D/OverheadLabel.text = "!"
				$OverheadNode2D/OverheadLabel.show()
				return
	if start_quests:
		for start_quest_id in start_quests:
			if Quests.quests[start_quest_id].status == Quests.NOT_STARTED and not Quests.is_quest_blocked(start_quest_id):
				$OverheadNode2D.visible = true
				$OverheadNode2D/blue_smile.visible = false
				$OverheadNode2D/OverheadLabel.text = "?"
				$OverheadNode2D/OverheadLabel.show()
				return
	if interaction_sentence_id:
		var has_done_this_interaction = true
		if "S" in interaction_sentence_id:
			has_done_this_interaction = int(interaction_sentence_id.replace("S", "")) in Game.known_sentences
		elif "I" in interaction_sentence_id:
			return  # TODO: we don't store done interactions yet!
		if has_done_this_interaction:
			will_pokecome = false
			temporarily_interact_when_near = false
		else:
			will_pokecome = true
			$OverheadNode2D.visible = true
			$OverheadNode2D/OverheadLabel.hide()
			$OverheadNode2D/blue_smile.visible = true
			return
	$OverheadNode2D.visible = false

func make_animation(animation_name, key_1, key_2, key_3, key_4):
	var animation = Animation.new()
	animation.add_track(Animation.TYPE_VALUE)
	animation.length = 0.8
	var path = String($Sprite.get_path()) + ":frame"
	animation.track_set_path(0, path)
	animation.track_insert_key(0, 0.0, key_1)
	animation.track_insert_key(0, 0.2, key_2)
	animation.track_insert_key(0, 0.4, key_3)
	animation.track_insert_key(0, 0.6, key_4)
	animation.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	animation.loop = 1
	$AnimationPlayer.add_animation(animation_name, animation)
	$AnimationPlayer.set_current_animation(animation_name)

func make_animations():
	make_animation("walk_down", 1, 0, 2, 0)
	make_animation("walk_right", 4, 3, 5, 3)
	make_animation("walk_left", 7, 6, 8, 6)
	make_animation("walk_up", 10, 9, 11, 9)
	make_animation("stand_down", 0, 0, 0, 0)
	make_animation("stand_right", 3, 3, 3, 3)
	make_animation("stand_left", 6, 6, 6, 6)
	make_animation("stand_up", 9, 9, 9, 9)

func update_animation():
	$AnimationPlayer.play(state + "_" + direction)

func dialog_option(dialog_, answer_index):
	Game.current_scene.handle_dialog_option(dialog_, answer_index, self)

func _ready():
	$Sprite.texture = load(sprite_path)
	$Sprite.vframes = 1
	$Sprite.hframes = 12
	make_animations()
	update_animation()
	over_head_label_y = $OverheadNode2D.position.y
	update_npc_overhead()
	initial_position = position
	if sold_entities:
		post_dialog_event= ["starts_vending", sold_entities]
	if interaction_sentence_id:
		post_dialog_event= ["starts_interaction_test", [interaction_sentence_id, self]]

func _process(delta):
	time += delta
	if white_orb_growing:
		$SpecialEffect/WhiteCircle.scale.x += delta * 4
		$SpecialEffect/WhiteCircle.scale.y += delta * 4
	if white_orb_fading:
		alpha = max(0, alpha - delta)
		$SpecialEffect/WhiteCircle.modulate = Color(1, 1, 1, alpha)
		if alpha == 0:
			free_npc()
	if $OverheadNode2D.is_visible():
		$OverheadNode2D.position.y = over_head_label_y + 3 * cos(time * 10)
	if not is_talking:
		if is_walking_towards:
			position = position + velocity * delta * speed
			if position.distance_to(is_walking_towards) < 5:
				is_walking_towards = null
				if will_go_to:
					is_walking_towards = will_go_to.pop_front()
				if not is_walking_towards:
					stop_walking()
				elif str(is_walking_towards) == "disappears":
					queue_free()
				else:
					starts_going_toward(is_walking_towards)
		elif wanders:
			if randi() % 100 == 1:
				var next_x = initial_position.x + randi() % wanders - wanders / 2
				var next_y = initial_position.y + randi() % wanders - wanders / 2
				starts_going_toward(Vector2(next_x, next_y))

func stop_walking():
	is_walking_towards = null
	state = "stand"
	velocity = Vector2.ZERO
	update_animation()
	
func starts_going_toward(target_position):
	is_walking_towards = target_position
	state = "walk"
	velocity = (target_position - position).normalized()
	npc_turn_towards(target_position)
	update_animation()

#func _on_InteractBox_area_entered(body) -> void:
#		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
#		Game.current_dialog.dialog = dialog
#		var current_map = get_tree().current_scene
#		current_map.add_child(Game.current_dialog)

func disappear_in_white_orb():
	$SpecialEffect/WhiteCircle.show()
	white_orb_growing = true
	# a white orb expands from the NPC
	# When the white orbs makes the entire screen, the NPC disappears
	# The white orb becomes more transparent
	var timer_to_hide_npc = Timer.new()
	timer_to_hide_npc.connect("timeout", self, "hide_npc_and_white_orb_fades")
	timer_to_hide_npc.set_wait_time(0.3)
	timer_to_hide_npc.set_one_shot(true)
	timer_to_hide_npc.autostart = true
	timer_to_hide_npc.start()
	add_child(timer_to_hide_npc)
	
func hide_npc_and_white_orb_fades():
	white_orb_fading = true
	$Sprite.hide()
	$Shadow.hide()
	
func free_npc():
	queue_free()

func npc_turn_towards(target):
	# Turns toward the Vector2 target (can be a place to go, the player...)
	var direction_vector = (target - position).normalized()
	var angle = (atan2(direction_vector.y, direction_vector.x) * 4 / PI + 3) / 2
	if angle < 0 or angle >= 3:
		direction = "left"
	elif angle < 1:
		direction = "up"
	elif angle < 2:
		direction = "right"
	else:
		direction = "down"
#	state = "stand"
	if not is_walking_towards:
		stop_walking()
	update_animation()

func set_direction(_direction):
	direction = _direction
	update_animation()

func handle_talk_with_this_npc_quest():
	for quest_id in Quests.quests:
		if (
			Quests.quests[quest_id].status == Quests.IN_PROGRESS
			and Quests.quests[quest_id].type == "talk_to_npc"
			and Quests.quests[quest_id].parameters[0] == display_name
		):
			Quests.quests[quest_id].status = Quests.DONE
			Quests.update_quests_display()
			
func interact():
	if is_walking_towards and not (interact_when_near or temporarily_interact_when_near):
		return "error"
	is_talking = true
	state = "stand"
	handle_talk_with_this_npc_quest()
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.player.turn_towards_entity(position)
	npc_turn_towards(Game.player.position)
	var dialog_to_use = get_dialog_to_use()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog_to_use, self, post_dialog_event, false, null)
	Game.current_scene.add_child(Game.current_dialog)
	if pre_dialog_event:
		Events.execute(pre_dialog_event[0], pre_dialog_event[1])

func get_dialog_to_use():
	# By default, we use the dialog field in the NPC
	var new_dialog = dialog
	var lo = TranslationServer.get_locale()
	
	var found_finished_quest_id = null
	if finish_quests:
		var finished_quest_ids = Quests.get_finished_quest_ids()
		for finished_quest_id in finished_quest_ids:
			if finished_quest_id in finish_quests:
				found_finished_quest_id = finished_quest_id
				break
		if found_finished_quest_id:
			Quests.mark_quest_as_done(found_finished_quest_id)
			new_dialog = Quests.quests[found_finished_quest_id][lo + "_finish_dialog"]
	
	# the second highest priority is to start a new quest
	if start_quests:
		var starting_quest_id = get_starting_quest()
		if starting_quest_id:
			if (lo + "_start_dialog") in Quests.quests[starting_quest_id]:
				var quest_starting_dialog = Quests.quests[starting_quest_id][lo + "_start_dialog"]
				# if we have a finishing dialog, we append the starting dialog to it.
				if found_finished_quest_id:
					new_dialog += quest_starting_dialog
				else:
					new_dialog = quest_starting_dialog
	return new_dialog

# This is called by dialog_ends in dialog.gd
func start_quest():
	if start_quests:
		var starting_quest_id = get_starting_quest()
		if starting_quest_id:
			Quests.start_quest(starting_quest_id)

func get_starting_quest():
	var found_not_started_quest_id = null
	for id_of_quest_started_by_npc in start_quests:
		if Quests.quests[id_of_quest_started_by_npc].status == Quests.NOT_STARTED:
			if not Quests.is_quest_blocked(id_of_quest_started_by_npc):
				found_not_started_quest_id = id_of_quest_started_by_npc
				break
	return found_not_started_quest_id

func _on_InteractBox_body_entered(body):
	if not body == Game.player:
		return
	if interact_when_near:
		interact()
		return
	if temporarily_interact_when_near:
		interact()
		temporarily_interact_when_near = false
		stop_walking()
		return
	if is_walking_towards:
		return
	Game.gains_focus(self)

func _on_InteractBox_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)

func _on_Down_body_entered(body):
	if not body == Game.player:
		return
	if not will_pokecome:
		return
	if not direction == "down":
		return
	raycast_to_player()

func _on_Up_body_entered(body):
	if not body == Game.player:
		return
	if not will_pokecome:
		return
	if not direction == "up":
		return
	raycast_to_player()

func _on_Right_body_entered(body):
	if not body == Game.player:
		return
	if not will_pokecome:
		return
	if not direction == "right":
		return
	raycast_to_player()

func _on_Left_body_exited(body):
	if not body == Game.player:
		return
	if not will_pokecome:
		return
	if not direction == "left":
		return
	raycast_to_player()

func _physics_process(_delta):
	if want_to_check_if_can_move_towards_position:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(global_position, want_to_check_if_can_move_towards_position, [self], collision_mask)
		want_to_check_if_can_move_towards_position = null
		if result:
			print("I can't walk to player. Hit at point: ", result.position)
		else:
			if will_pokecome:
				pokecome()

func pokecome():
	if self in Game.current_focus:
		interact()
		return
	Game.is_frozen = true
	# TODO: if player was walking using the mouse, stop it
	Game.player.goal_position = Game.player.position
	temporarily_interact_when_near = true
	starts_going_toward(Game.player.global_position)

func raycast_to_player():
	want_to_check_if_can_move_towards_position = Game.player.global_position
