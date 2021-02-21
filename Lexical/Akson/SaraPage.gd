extends Node2D

const CENTER = Vector2(320, 180) / 2
var direction = Vector2.ZERO
var speed = 100
const LIMIT_RIGHT = 400
const LIMIT_LEFT = -100
const LIMIT_UP = -180
const LIMIT_DOWN = 370

func _ready():
	$Camera.current = true
	get_viewport().warp_mouse(CENTER)
	for letter in $YSort/Letters.get_children():
		letter.connect("akson_letter_learnt", self, "akson_letter_learnt")

func akson_letter_learnt(letter):
	print("letter is learnt ", letter)
	for cloud in $YSort/Clouds.get_children():
		if letter in cloud.lift_on_letters:
			cloud.lift()

func _input(event):
	if Game.is_frozen or Game.current_dialog:
		return
	if event is InputEventMouseMotion:
		var distance_to_center = event.position.distance_squared_to(CENTER)
		if distance_to_center > 1500:
			var intensity = (distance_to_center - 1500) / 40
			direction = (event.position - CENTER).normalized()
			speed = min(intensity, 500)
		else:
			direction = Vector2.ZERO

func _process(delta):
	if direction:
		$Camera.position += direction * delta * speed
		limit_movement()

func limit_movement():
	if $Camera.position.x > LIMIT_RIGHT:
		$Camera.position.x = LIMIT_RIGHT
	if $Camera.position.x < LIMIT_LEFT:
		$Camera.position.x = LIMIT_LEFT
	if $Camera.position.y > LIMIT_DOWN:
		$Camera.position.y = LIMIT_DOWN
	if $Camera.position.y < LIMIT_UP:
		$Camera.position.y = LIMIT_UP

func exit():
	Game.player.get_node("Camera2D").current = true
	queue_free()

func _physics_process(delta):
	if Game.is_frozen or Game.current_dialog:
		return
	var input_vector_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_vector_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input_vector = Vector2(input_vector_x, input_vector_y).normalized()
	if input_vector != Vector2.ZERO:
		$Camera.position += input_vector * delta * 200
		limit_movement()
		update_letters_focus()
		get_viewport().warp_mouse(CENTER)

func update_letters_focus():
	for letter in $YSort/Letters.get_children():
		if letter.position.distance_squared_to($Camera.position) < 200:
			letter._on_Button_mouse_entered()
		else:
			letter._on_Button_mouse_exited()
