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
var links = []

# variables linked to following
export var is_following_player = false
var following_speed = 1000
var MAX_FOLLOWING_SPEED = 100
var closeness_to_player = 15
var lo = TranslationServer.get_locale()
var random_following_offset = Vector2.ZERO

# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

func _ready():
	if Game.palace:
		$CollisionShape2D.disabled = true
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

func remove_following_word():
	var new_following_words = []
	for following_word in Game.following_words:
		if not following_word.over_word == self:
			new_following_words.append(following_word)
	Game.following_words = new_following_words
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
	if not Game.palace:
		start_test()
		return
	var dialog = tr("_what_to_do_with_word").replace("[Word]", word.th)
	if links:
		dialog += "/" + tr("_teleport")
	get_tree().set_input_as_handled()
	Game.is_frozen = true
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog([dialog], self, null, false, null)
	Game.current_dialog.id = "what_to_do_with_word"
	Game.current_scene.add_child(Game.current_dialog)

func dialog_option(dialog, option):
	if dialog.id == "what_to_do_with_word":
		var MOVE_IT = 1
		var USE_ITS_POWER = 2
		var SEE_WORD = 3
		var TELEPORT = 4
		if option == MOVE_IT:
			Game.add_following_word(id, self)
			Game.palace.get_node("WordNet").remove_word(self)
			links = []
			Game.lose_focus(self)
			Game.gains_focus(Game.palace)
		elif option == TELEPORT:
			var dialog_text = tr("_to_which_word_do_you_want_to_go") + " @Q"
			var options = PoolStringArray([])
			for link in links:
				print('link---', link.word_1.word.th, ', ', link.word_2.word.th)
			for link in links:
				if link.word_1 != self and not link.word_1.word.th in options:
					options.append(link.word_1.word.th)
				if link.word_2 != self and not link.word_2.word.th in options:
					options.append(link.word_2.word.th)
			print('options')
			print(options)
			dialog_text += options.join("/")
			get_tree().set_input_as_handled()
			Game.is_frozen = true
			Game.player.stop_walking()
			Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
			Game.current_dialog.init_dialog([dialog_text], self, null, false, null)
			Game.current_dialog.id = "teleport_to_which_word"
			Game.current_scene.add_child(Game.current_dialog)
	elif dialog.id == "teleport_to_which_word":
		var options = []
		for link in links:
			if link.word_1 != self and not link.word_1 in options:
				options += [link.word_1]
			if link.word_2 != self and not link.word_2 in options:
				options += [link.word_2]
		var selected_option = options[option - 1]
		Game.player.position = selected_option.position
		
func start_test():
	Game.is_frozen = true
	var test_start_animation = load("res://Test/TestStartAnimation.tscn").instance()
	test_start_animation.init_start_animation(word["th"], "Spell")
	self.add_child(test_start_animation)
	test_start_animation.connect("test_can_start", self, "start_test_after_animation")

func start_test_after_animation():
	var first_test = "res://Test/Word/TestSoundFromWord.tscn"
#	var first_test = "res://Test/Word/TestWordCopyTyping.tscn"
	Game.start_test(first_test, id, self)

func _on_Area2D_body_entered(body):
	if is_following_player:
		return
	if not body == Game.player:
		return
	if Game.palace:
		Game.gains_focus(self)
		return
#	if the Spell starts the interaction
	if not Game.is_overworld_frozen() and not is_frozen:
		interact()

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)


func _on_GreaterZone_body_entered(body):
	# Used in the Palace to make its links visible
	if not body == Game.player:
		return
	if not Game.palace:
		return
	for link in links:
		link.becomes_opaque()

func _on_GreaterZone_body_exited(body):
	# Used in the Palace to make its links transparent
	if not body == Game.player:
		return
	if not Game.palace:
		return
	for link in links:
		link.becomes_transparent()
