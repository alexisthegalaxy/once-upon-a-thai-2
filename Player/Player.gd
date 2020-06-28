extends KinematicBody2D

const ACCELERATION = 1200
const SPEED = 40
const FRICTION = 1200
const MAX_SPEED = 120
const ROLL_SPEED = 180

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
export var state = "stand"  # can be "stand" or "walk"
export var direction = "down"
var speed_when_forced = 75
var can_interact = true  # meaning the player is near a npc. false during a dialog.

var dict = null
var hub = null
var alphabet = null
var notebook = null
var is_forced_towards = null
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

func _ready() -> void:
	$Sprite.texture = load(Game.player_sprite_path)
	$Sprite.vframes = 1
	$Sprite.hframes = 12
	make_animations()
	update_animation()
	Game.player = self
	print('player is ', self)

func _physics_process(delta) -> void:
	if is_forced_towards:
		position = position + velocity * delta * speed_when_forced
		if position.distance_to(is_forced_towards) < 3:
			is_forced_towards = null
	else:
		move_state(delta)
	
func _on_press_f():
	if hub:
		hub.queue_free()
		hub = null
	elif dict:
		dict.queue_free()
		dict = null
	elif alphabet:
		alphabet.queue_free()
		alphabet = null
	else:
		hub = load("res://UI/UIHub.tscn").instance()
		hub.init(self)
		get_tree().current_scene.add_child(hub)

func _input(_event) -> void:
	if Input.is_action_just_pressed("interact"):
		print('can_interact ', can_interact)
		print('Game.current_focus ', Game.current_focus)
	if can_interact and Game.current_focus and is_instance_valid(Game.current_focus[0]) and Input.is_action_just_pressed("interact"):
		can_interact = false
		Game.can_move = false
		Game.current_focus[0].interact(self)
		if Game.space_bar_to_interact:
			Game.space_bar_to_interact.queue_free()
			Game.space_bar_to_interact = null
	if Input.is_action_just_pressed("print_position"):
		print("(" + str(position.x) + ", " + str(position.y) + ")")
		set_hp(Game.hp - 0.5)
#		Game.add_random_letter_to_letters_to_look_for()
	if Input.is_action_just_pressed("print_known_sentences"):
		Game.print_known_sentences()
	if Input.is_action_just_pressed("hub"):
		_on_press_f()

func stop_walking():
	update_state("stand")
	velocity = Vector2.ZERO

func update_state(_state):
	state = _state
	update_animation()

func move_state(delta) -> void:
	if not Game.can_move:
		return
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	move(input_vector, delta)

func move(input_vector, delta) -> void:
	if Input.get_action_strength("ui_down") > 0:
		direction = "down"
	if Input.get_action_strength("ui_up") > 0:
		direction = "up"
	if Input.get_action_strength("ui_right") > 0:
		direction = "right"
	if Input.get_action_strength("ui_left") > 0:
		direction = "left"
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		update_state("walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if velocity.length() < 1:
		update_state("stand")
	velocity = move_and_slide(velocity)

func end_dialog() -> void:
	can_interact = true
	Game.can_move = true

func set_hp(hp) -> void:
	Game.hp = hp
	$HUD/HpBar.set_life(hp, Game.max_hp)

func forced_toward(target_position):
	is_forced_towards = target_position
	velocity = (target_position - position).normalized()
	Game.can_move = false
	
	
