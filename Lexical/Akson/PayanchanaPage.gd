extends CanvasLayer

const CENTER = Vector2(320, 180) / 2
var direction = Vector2.ZERO
var speed = 100
const LIMIT_RIGHT = 100
const LIMIT_LEFT = -280
const LIMIT_UP = -120
const LIMIT_DOWN = 190

func init_akson_subpage():
	var payanchanas = []
	for letter in Game.letters_we_look_for:
		if letter["class"] in ['LOW', 'MID', 'HIGH']:
			payanchanas.append(letter)
	$LettersWeLookFor.init_letters_we_look_for(payanchanas)
	_lift_clouds_for_known_letters()

func _lift_clouds_for_known_letters():
	for cloud in $Objects/YSort/Clouds.get_children():
		for letter_id in Game.known_letters:
			if Game.letters[str(letter_id)].th in cloud.lift_on_letters:
				cloud.lift()

func _ready():
	get_viewport().warp_mouse(CENTER)
	for letter in $Objects/YSort/Letters.get_children():
		letter.connect("akson_letter_learnt", self, "akson_letter_learnt")

func akson_letter_learnt(letter):
	if $LettersWeLookFor:
		$LettersWeLookFor.update_label_text()
	for cloud in $Objects/YSort/Clouds.get_children():
		if letter in cloud.lift_on_letters:
			cloud.lift()

func _input(event):
	if Game.active_letter_test or Game.current_dialog:
		return
	if event is InputEventMouseMotion:
		var distance_to_center = event.position.distance_squared_to(CENTER)
		if distance_to_center > 4000:
			var intensity = (distance_to_center - 4000) / 40
			direction = (event.position - CENTER).normalized()
			speed = min(intensity, 500)
		else:
			direction = Vector2.ZERO

func _process(delta):
	# Moving using the mouse
	if Game.active_letter_test or Game.current_dialog:
		return
	if direction:
		$Objects.position -= direction * delta * speed
		limit_movement()

func limit_movement():
	if $Objects.position.x > LIMIT_RIGHT:
		$Objects.position.x = LIMIT_RIGHT
	if $Objects.position.x < LIMIT_LEFT:
		$Objects.position.x = LIMIT_LEFT
	if $Objects.position.y > LIMIT_DOWN:
		$Objects.position.y = LIMIT_DOWN
	if $Objects.position.y < LIMIT_UP:
		$Objects.position.y = LIMIT_UP

func exit():
	var akson = load("res://Lexical/Akson/Akson.tscn").instance()
	Game.akson = akson
	akson.init_akson([])
	Game.current_scene.add_child(akson)
	queue_free()

func _physics_process(delta):
	# Moving using the keyboard
	if Game.active_letter_test or Game.current_dialog:
		return
	var input_vector_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var input_vector_y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	var input_vector = Vector2(input_vector_x, input_vector_y).normalized()
	if input_vector != Vector2.ZERO:
		$Objects.position -= input_vector * delta * 200
		limit_movement()
		update_letters_focus()
		get_viewport().warp_mouse(CENTER)

func update_letters_focus():
	for letter in $Objects/YSort/Letters.get_children():
		if letter.position.distance_squared_to(CENTER) < 200:
			letter._on_Button_mouse_entered()
		else:
			letter._on_Button_mouse_exited()
