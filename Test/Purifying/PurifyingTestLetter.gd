extends KinematicBody2D

var velocity
#var rng = RandomNumberGenerator.new()
const CENTER = Vector2(320/2, 180/2)
var letter_id
var letter
signal purifying_letter_is_selected

func init_purifying_test_letter(_letter_id):
	self.position = Vector2(randi() % 320, randi() % 180)
	velocity = CENTER - self.position
	letter_id = _letter_id
	letter = Game.letters[str(letter_id)]
	$Letter.text = letter.th

func _process(delta):
	if not letter_id:
		return
#	var next_position = self.position + velocity * delta
#	velocity = self.move_and_slide(velocity)
#	velocity = self.move_and_collide(velocity)
	var collision = move_and_collide(velocity * delta)
	if collision:
		# To make the other kinematicbody2d move as well
		collision.collider.move_and_collide(velocity * delta)
	
	if randi() % 100 == int(letter_id / 10):
		velocity = (CENTER - self.position) / 3

func _on_Button_pressed():
	emit_signal("purifying_letter_is_selected", self)
