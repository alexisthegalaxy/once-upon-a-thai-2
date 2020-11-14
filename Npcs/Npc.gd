extends StaticBody2D

export(Array) var dialog = []
export var sprite_path = "res://Npcs/sprites/yaai.png"
export var direction = "down"
export var state = "stand"  # can be "stand" or "walk"
var speed = 65
var velocity = Vector2.ZERO
var is_walking_towards = null
var will_go_to = []  # array of vector2 positions
# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

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

func dialog_option(_value):
	pass

func _ready():
	$Sprite.texture = load(sprite_path)
	$Sprite.vframes = 1
	$Sprite.hframes = 12
	make_animations()
	update_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_walking_towards:
		position = position + velocity * delta * speed
		if position.distance_to(is_walking_towards) < 5:
			is_walking_towards = null
			if will_go_to:
				is_walking_towards = will_go_to.pop_front()
			if not is_walking_towards:
				stop_walking()
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
		Game.player.can_interact = false
		Game.can_move = false
		npc_turn_towards(Game.player.position)
		Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
		Game.current_dialog.init(dialog, self, post_dialog_event, false)
		Game.player.stop_walking()
		get_tree().current_scene.add_child(Game.current_dialog)
		if pre_dialog_event:
			Events.execute(pre_dialog_event[0], pre_dialog_event[1])
	else:
		Game.can_move = true

func _on_InteractBox_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_InteractBox_body_exited(body):
	if body == Game.player:
		Game.loses_focus(self)
