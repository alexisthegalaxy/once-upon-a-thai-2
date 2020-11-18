extends StaticBody2D

export(Array) var dialog = []
export var sprite_path = "res://Npcs/sprites/yaai.png"
export var direction = "down"
export var state = "stand"  # can be "stand" or "walk"
export var display_name = ""  # Is shown in dialogs. For example: "Nim".

var speed = 100  # 65
var velocity = Vector2.ZERO
var is_walking_towards = null
var will_go_to = []  # array of vector2 positions
# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

# white orb disappearance
var white_orb_growing = false
var white_orb_fading = false
var alpha = 1

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
	$AnimationPlayer.play(state  + "_" + direction)

func dialog_option(parameters):
	var dialog_node = parameters[0]
	var chosen_option = parameters[1]
	
	if sprite_path == "res://Npcs/sprites/pet.png":
		if chosen_option == 3:
			dialog = ["Pet: Hmph, yeah. In any case, I’ve got important stuff to do in Chaiyaphum. Smell ya later, loser!"]
			dialog_node.dialog = dialog
			dialog_node.page = -1
			SoundPlayer.play_sound("res://Sounds/ding.wav")
		else:
			dialog = ["Pet: See? \"bpai\" is written ไป. In any case, I’ve got important stuff to do in Chaiyaphum. Smell ya later, loser!"]
			dialog_node.dialog = dialog
			dialog_node.page = -1
			SoundPlayer.play_sound("res://Sounds/incorrect.wav")
		post_dialog_event = ["npc_walks_to", [[
			Vector2(543.984375, 244.238388),
			Vector2(543.984375, 100.238388),
			Vector2(359.984375, 100.238388),
			Vector2(359.984375, 54.238388),
			Vector2(438.039154, -15.019601),
			Vector2(534.457153, -30.081276),
			Vector2(596.457153, -30.081276),
			Vector2(657.126892, -52.954685),
			Vector2(657.126892, 11.045315),
			Vector2(782.301086, 115.493446),
			Vector2(1187.967773, 115.493446),
			Vector2(1187.967773, 260.826782),
			Vector2(1297.967773, 260.826782),
			Vector2(1297.967773, 291.826782),
			Vector2(1297.967773, 257.826782),
			Vector2(1298, 177),
			"disappears"
		]]]
		dialog_node.post_dialog_event = post_dialog_event
#		Game.player.can_interact = false
#		Game.can_move = false
#		interact()

func _ready():
	$Sprite.texture = load(sprite_path)
	$Sprite.vframes = 1
	$Sprite.hframes = 12
	make_animations()
	update_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if white_orb_growing:
		$SpecialEffect/WhiteCircle.scale.x += delta * 4
		$SpecialEffect/WhiteCircle.scale.y += delta * 4
	if white_orb_fading:
		alpha = max(0, alpha - delta)
		$SpecialEffect/WhiteCircle.modulate = Color(1, 1, 1, alpha)
		if alpha == 0:
			free_npc()
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

func interact():
	if not is_walking_towards:
		get_tree().set_input_as_handled()
		Game.player.can_interact = false
		Game.can_move = false
		npc_turn_towards(Game.player.position)
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		Game.current_dialog.init_dialog(dialog, self, post_dialog_event, false, null)
		Game.player.stop_walking()
		Game.current_scene.add_child(Game.current_dialog)
		if pre_dialog_event:
			Events.execute(pre_dialog_event[0], pre_dialog_event[1])
	else:
		Game.can_move = true

func _on_InteractBox_body_entered(body):
	if is_walking_towards:
		return
	if not body == Game.player:
		return
	Game.gains_focus(self)

func _on_InteractBox_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)
