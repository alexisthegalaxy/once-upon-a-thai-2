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

var time = 0

var arrow = null  # the arrow that is sometimes shown to indicate direction to follow
# UI
var hub = null  # The screen that appears when pressing f and gives access to sentences, etc.
var dict = null
var alphabet = null
var notebook = null
var word_page = null
var letter_page = null

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
	arrow = $Arrow
	arrow.hide()

func _physics_process(delta) -> void:
	if is_forced_towards:
		position = position + velocity * delta * speed_when_forced
		if position.distance_to(is_forced_towards) < 3:
			is_forced_towards = null
	else:
		move_state(delta)

func _process(delta) -> void:
	if Game.is_somber:
		time += delta
		if int(time) % 19 > 16 or int(time) % 5 >= 4:
			$Camera2D.position.x = 2.5 * cos(time * 20)
		else:
			$Camera2D.position.x = 0
	else:
		if not $Camera2D.position.x == 0:
			$Camera2D.position.x = 0
	
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
	elif notebook:
		notebook.queue_free()
		notebook = null
	elif word_page:
		word_page.queue_free()
		word_page = null
	elif letter_page:
		letter_page.queue_free()
		letter_page = null
	elif Game.select_follower_to_implant_screen:
		Game.select_follower_to_implant_screen.queue_free()
		Game.select_follower_to_implant_screen = null
	elif Game.deducing_coop_select_sentence_screen:
		Game.deducing_coop_select_sentence_screen.queue_free()
		Game.deducing_coop_select_sentence_screen = null
		Game.is_frozen = false
	elif Game.vending_screen:
		Game.vending_screen.queue_free()
		Game.vending_screen = null
		Game.is_frozen = false
	else:
		hub = load("res://UI/UIHub.tscn").instance()
		Game.current_scene.add_child(hub)

func _input(_event) -> void:
	if Input.is_action_just_pressed("interact") and not Game.is_overworld_frozen() and can_interact and Game.current_focus and is_instance_valid(Game.current_focus[0]):
		get_tree().set_input_as_handled()
		Game.player.can_interact = false
		Game.is_frozen = true
		Game.current_focus[0].interact()
		if Game.space_bar_to_interact:
			Game.space_bar_to_interact.queue_free()
			Game.space_bar_to_interact = null
	if Input.is_action_just_pressed("print_position"):
		print("current position: (" + str(position.x) + ", " + str(position.y) + ")")
#		set_hp(Game.hp - 0.5)
		Game.letters_we_look_for.append(Game.letters["1"])
#		Game.add_random_letter_to_letters_to_look_for()
	if Input.is_action_just_pressed("print_known_sentences"):
		Game.print_known_sentences()
	if Input.is_action_just_pressed("save"):
		Save.save_game()
	if Input.is_action_just_pressed("load"):
		Save.load_game("Alexis")
	if Input.is_action_just_pressed("hub"):
		_on_press_f()

func stop_walking():
	update_state("stand")
	velocity = Vector2.ZERO

func update_state(_state):
	state = _state
	update_animation()

func move_state(delta) -> void:
	if Game.is_overworld_frozen():
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
#	velocity = move_and_slide(Vector2(floor(velocity.x), floor(velocity.y)))

func end_dialog() -> void:
	can_interact = true
	Game.is_frozen = false

func set_hp(hp) -> void:
	Game.hp = hp
	$HUD/HpBar.set_life(hp, Game.max_hp)

func forced_toward(target_position):
	is_forced_towards = target_position
	velocity = (target_position - position).normalized()
	Game.is_frozen = true

func save_game():
	var player_data = {}
	player_data.x = position.x
	player_data.y = position.y
	player_data.sprite = Game.player_sprite_path
	player_data.direction = direction
	return player_data
	
func load_game(player_data):
	position.x = player_data.x
	position.y = player_data.y
	Game.player_sprite_path = player_data.sprite
	direction = player_data.direction

func turn_towards_entity(target):
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
	update_animation()
