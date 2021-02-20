extends Node2D

const CENTER = Vector2(320, 180) / 2
var direction = Vector2.ZERO
var speed = 100

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

func init_sara_page():
	pass

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
		if $Camera.position.x > 300:
			$Camera.position.x = 300
		if $Camera.position.x < 0:
			$Camera.position.x = 0
		if $Camera.position.y > 300:
			$Camera.position.y = 300
		if $Camera.position.y < -150:
			$Camera.position.y = -150

func _on_ExitButton_pressed():
	exit()

func exit():
	Game.player.get_node("Camera2D").current = true
	queue_free()
