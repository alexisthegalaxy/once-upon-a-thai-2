extends KinematicBody2D

export var id = 0

# Moving
const ACCELERATION = 1200 * 3
const FRICTION = 1200
const MAX_SPEED = 60  # 100
export var can_move = false
var velocity = Vector2.ZERO
var will_move_in = 0
var rng = RandomNumberGenerator.new()
var word
var is_disappearing = false
var ratio = 0.001
export var wobbles = true
var wobbling_time = 0
var y = 0
var is_birthing = true
var is_frozen = false

# variables linked to following
export var is_following_player = false
var following_speed = 1000
var MAX_FOLLOWING_SPEED = 90
var time_to_live
var closeness_to_player = 15

var random_following_offset = Vector2.ZERO

# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

func _ready():
	y = self.position.y
	word = Game.words[str(id)]
	$Visible/thai.text = word["th"]
	rng.randomize()
	if is_following_player:
		set_as_following()
	
func set_as_following():
	is_following_player = true
	can_move = true
	$CollisionShape2D.disabled = true
	$Visible/thai.add_color_override("font_color", Color(0.137, 1, 0.952, 1))
	$Visible.scale = Vector2(0.6, 0.6)
	$Visible/Light2D.hide()
	MAX_FOLLOWING_SPEED += randi() % 30 - 15
	random_following_offset = Vector2(randi() % 30 - 15, randi() % 30 - 15)
	closeness_to_player += randi() % 20 - 10
	time_to_live = 60  # in seconds

func remove_following_spell():
	var new_following_spells = []
	for following_spell in Game.following_spells:
		if not following_spell.over_word == self:
			new_following_spells.append(following_spell)
	Game.following_spells = new_following_spells
	starts_disappearing()

func _process(delta):
	if Game.is_overworld_frozen():
		return
#	if Game.player.position.distance_to(position) > 200:
#		$Light2D.hide()
#		return
#	$Visible/Light2D.show()
	if wobbles:
		wobbling_time += delta
		$Visible.position.y = cos(wobbling_time) * 5
	if is_following_player:
		if can_move:
			time_to_live -= delta
			if time_to_live < 0:
				remove_following_spell()
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
			
			Game.a_word_is_learnt()
	if can_move:
		if is_following_player:
			var player_position = Game.player.position + random_following_offset
			var direction = (player_position - position).normalized()
			if player_position.distance_to(position) > closeness_to_player:
				velocity = velocity.move_toward(direction * min(following_speed, MAX_FOLLOWING_SPEED), ACCELERATION * delta)
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
				velocity = 4 * Vector2(rng.randi() % MAX_SPEED - MAX_SPEED / 2.0, rng.randi() % MAX_SPEED - MAX_SPEED / 2.0)
			elif rng.randi() % 50 == 1:
				velocity = Vector2(0, 0)

func starts_disappearing():
	print('starts_disappearing')
	is_disappearing = true

# interact functions such as this one are lauched by the space_bar_to_interact in player.gd
func interact():
	Game.player.stop_walking()
	start_test()

func start_test():
	Game.is_frozen = true
	var test_start_animation = load("res://Test/TestStartAnimation.tscn").instance()
	test_start_animation.init_start_animation(word["th"], "Spell")
	self.add_child(test_start_animation)
	test_start_animation.connect("test_can_start", self, "start_test_after_animation" )

func start_test_after_animation():
	var first_test = "res://Test/TestGuessMeaning.tscn"
	Game.start_test(first_test, id, self)

func _on_Area2D_body_entered(body):
	if is_following_player:
		return
	if not body == Game.player:
		return
#	if the Player starts the interaction - keep commented out
#	Game.gains_focus(self)
#	if the Spell starts the interaction
	if not Game.is_overworld_frozen() and not is_frozen:
		interact()

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)
