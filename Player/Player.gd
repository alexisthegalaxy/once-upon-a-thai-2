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
var target  # the thing that the player is currently looking at, for interacting with
var can_move = true  # false when interacting with a npc, etc.
var can_interact = false  # meaning the player is near a npc. false during a dialog.
var state = MOVE
var dict = null

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready() -> void:
	print('player', self)
	animationTree.active = true

func _physics_process(delta) -> void:
	match state:
		MOVE:
			if can_move:
				move_state(delta)
		ROLL:
			roll_state(delta)
	
func _input(_event) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		# print('interac')
		if target:
			# print('with target', target)
			can_interact = false
			can_move = false
			target.initiate_dialog(self)
	if Input.is_action_just_pressed("print_position"):
		print("(" + str(position.x) + ", " + str(position.y) + ")")
	if Input.is_action_just_pressed("dict"):
		if dict:
			dict.queue_free()
			dict = null
		else:
			dict = load("res://Lexical/Dict/Dict.tscn").instance()
			dict.init(self)
			var current_map = get_tree().current_scene
			current_map.add_child(dict)


func move_state(delta) -> void:
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

func _on_InteractBox_body_entered(npc) -> void:
#	can_move = false
#	velocity = Vector2.ZERO
	can_interact = true
	target = npc
	animationState.travel("Idle")
	# print('player has entered zone around ', npc)

func _on_InteractBox_body_exited(_npc) -> void:
	can_interact = false
	target = null


func end_dialog() -> void:
	can_interact = true
	can_move = true
