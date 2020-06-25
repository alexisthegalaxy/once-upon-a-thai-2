extends KinematicBody2D

const ACCELERATION = 1200
const SPEED = 40
const FRICTION = 1200
const MAX_SPEED = 120
const ROLL_SPEED = 180

var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

enum {
	MOVE,
	ROLL,
}
var player_name = "Alexis"
var can_interact = true  # meaning the player is near a npc. false during a dialog.
var state = MOVE

var dict = null
var hub = null
var alphabet = null
var notebook = null

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready() -> void:
	animationTree.active = true
	Game.player = self
	print('player is ', self)

func _physics_process(delta) -> void:
	match state:
		MOVE:
			if Game.can_move:
				move_state(delta)
		ROLL:
			roll_state(delta)
	
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
	if can_interact and Game.current_focus and Input.is_action_just_pressed("interact"):
		can_interact = false
		Game.can_move = false
		Game.current_focus.interact(self)
		Game.space_bar_to_interact.queue_free()
		Game.space_bar_to_interact = null
	if Input.is_action_just_pressed("print_position"):
		print("(" + str(position.x) + ", " + str(position.y) + ")")
		set_hp(Game.hp - 0.5)
		Game.add_random_letter_to_letters_to_look_for()
	if Input.is_action_just_pressed("print_known_sentences"):
		Game.print_known_sentences()
	if Input.is_action_just_pressed("hub"):
		_on_press_f()

func move_state(delta) -> void:
	if not Game.can_move:
		return
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL


func move() -> void:
	velocity = move_and_slide(velocity)

func attack_state(_delta) -> void:
	velocity = Vector2.ZERO 
	animationState.travel("Attack")


func roll_state(_delta) -> void:
	animationState.travel("Roll")
	velocity = roll_vector * ROLL_SPEED
	move()
	
func roll_animation_finished() -> void:
	state = MOVE 

func attack_animation_finished() -> void:
	state = MOVE

func end_dialog() -> void:
	can_interact = true
	Game.can_move = true

func set_hp(hp) -> void:
	Game.hp = hp
	$HUD/HpBar.set_life(hp, Game.max_hp)
