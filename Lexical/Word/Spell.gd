extends KinematicBody2D

export var id = 0
export var is_following_player = false

# Moving
const ACCELERATION = 1200
const FRICTION = 1200
const MAX_SPEED = 30  # 100
export var can_move = false
var velocity = Vector2.ZERO
var will_move_in = 0
var rng = RandomNumberGenerator.new()
var following_speed = 1000
var word
var is_disappearing = false
var ratio = 0.001
export var wobbles = true
var wobbling_time = 0
var y = 0
var is_birthing = true

# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

func _ready():
	y = self.position.y
	word = Game.words[str(id)]
	$Sprite/label.text = word["th"]
	rng.randomize()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.is_overworld_frozen():
		return
#	if Game.player.position.distance_to(position) > 200:
#		$Sprite/Light2D.hide()
#		return
	$Sprite/Light2D.show()
	if wobbles and not can_move:
		wobbling_time += delta
		var wobbling_delta = cos(wobbling_time) * 3
#		self.position.y = y + wobbling_delta
		$Sprite.position.y = $Sprite.position.y + wobbling_delta / 50
#		 * $Sprite.scale.x

	if is_birthing:
		if ratio < 1:
			ratio += delta
			self.scale.x = ratio
			self.scale.y = ratio
		else:
			is_birthing = false
			self.scale.x = 1
			self.scale.y = 1

	if is_disappearing:
		ratio -= 3 * delta
		self.scale.x = ratio
		self.scale.y = ratio
		if ratio <= 0:
			queue_free()
			if len(Game.known_words) == 6:
				Game.pop_victory_screen()
	if can_move:
#		print('is_following_player', is_following_player)
		if is_following_player:
			var player_position = Game.player.position
#			print('player_position', player_position)
			var direction = (player_position - position).normalized()
#			print('direction', direction)
			if player_position.distance_to(position) > 15:
				velocity = velocity.move_toward(direction * following_speed, ACCELERATION * delta)
			else:
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				velocity = move_and_slide(velocity)
#			move(direction * following_speed, delta)
#				self.move_and_slide(velocity)
#						position = position + velocity * delta * speed
		else:
	#		var next_position = self.position + velocity * delta
			velocity = self.move_and_slide(velocity)
			if rng.randi() % 50 == 1:
				velocity = 4 * Vector2(rng.randi() % MAX_SPEED - MAX_SPEED / 2, rng.randi() % MAX_SPEED - MAX_SPEED / 2)
			elif rng.randi() % 50 == 1:
				velocity = Vector2(0, 0)

func starts_disappearing():
	is_disappearing = true

func interact():
	Game.player.stop_walking()
	Game.start_test("res://Test/TestGuessMeaning.tscn", id, self)

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.loses_focus(self)
