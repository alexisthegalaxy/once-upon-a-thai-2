extends KinematicBody2D

export var id = 0

# Moving
const ACCELERATION = 1200 * 3
const FRICTION = 1200
const MAX_SPEED = 60  # 100
export var can_move = false
var velocity = Vector2.ZERO
var will_move_in = 0
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
var MAX_FOLLOWING_SPEED = 100
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
				if not ((id == 401 and Quests.quests.implant_any_source_with_dtat.status == Quests.IN_PROGRESS) or (id == 56 and Quests.quests.implant_source_behind_the_temple.status == Quests.IN_PROGRESS)):
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
			wild_spell_movement()
			if Game.is_somber:
				$Visible/Sprite.modulate = Color(0, 0, 0, 1)
			else:
				$Visible/Sprite.modulate = Color(1, 1, 1, 1)

func wild_spell_movement():
	var change_direction_chance = 50
	var stops_moving_chance = 50
	var speed_multiplier = 1.7
	if Game.is_somber:
		change_direction_chance = 10
		stops_moving_chance = 100
		speed_multiplier = 2
	velocity = self.move_and_slide(velocity)
	if randi() % change_direction_chance == 1:
		var max_speed = MAX_SPEED * speed_multiplier
		var x_speed = rand_range(-max_speed, max_speed)
		var y_speed = rand_range(-max_speed, max_speed)
		velocity = Vector2(x_speed, y_speed)
	elif randi() % stops_moving_chance == 1:
		velocity = Vector2(0, 0)

func starts_disappearing():
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
	test_start_animation.connect("test_can_start", self, "start_test_after_animation")

func start_test_after_animation():
#	var first_test = "res://Test/Word/TestSoundFromWord.tscn"
	var first_test = "res://Test/Word/TestWordCopyTyping.tscn"
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
