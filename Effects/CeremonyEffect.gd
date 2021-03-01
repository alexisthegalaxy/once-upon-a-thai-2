 extends Node2D

onready var initial_words = [$"แรง", $"ลืม", $"คำ", $"ผี", $"เห็น"]

var time = 0
var time_create_word = 0
var darkness = 0
var initial_word_visibility = 0
var distance_to_center = 50
var turning_speed = 1
const TURN_FIFTH = 2 * PI / 5
var phase = 0
var word_index
var center
var y_delta
const y_initial_delta = 20
var time_to_next_word_creation = 0.5
var released_words = 0
var yaai = null

"""
Phase 1:
	Can't move
	Initial words slowly rise from the ground, get visible
	Music starts
Phase 2:
	Initial words turn quickly around the player.
	Words are emitted in all directions
	
	
"""

func _ready():
	finish()
	center = Game.player.position
	position = center
	phase = 1
	word_index = 0
	SoundPlayer.crossfade_to("res://Sounds/DevarieuxMusic/Foret 2em cristal.wav", 2.95)
	Game.is_frozen = true
	Game.lose_focus(0)
	for word in initial_words:
		word.position = Vector2(
			cos(word_index * TURN_FIFTH) * distance_to_center,
			sin(word_index * TURN_FIFTH) * distance_to_center + y_initial_delta)
		word_index += 1
		word.modulate = Color(1, 1, 1, 0)

func _init_phase_4():
	phase = 4
	Game.is_frozen = false
	time = 0

func _process(delta):
	time += delta
	time_create_word += delta
	if phase == 1:
		if darkness < 0.5:
			darkness += delta / 5
			$ColorRect.modulate = Color(0, 0, 0, darkness)
		initial_word_visibility += 0.2 * delta
		for word in initial_words:
			word.position.y -= delta * 5
			word.modulate = Color(1, 1, 1, initial_word_visibility)
		if initial_word_visibility >= 1:
			initial_word_visibility = 1
			phase = 2
			time = 0
			y_delta = initial_words[0].position.y - sin(word_index * TURN_FIFTH) * distance_to_center
	if phase == 2:
		word_index = 0
		for word in initial_words:
			word.position = Vector2(
				cos(time * turning_speed + word_index * TURN_FIFTH) * distance_to_center,
				sin(time * turning_speed + word_index * TURN_FIFTH) * distance_to_center + y_delta)
			word_index += 1
		turning_speed += delta / 3
		if time_create_word > time_to_next_word_creation:
			time_create_word = 0
			time_to_next_word_creation = time_to_next_word_creation * 0.95
			var ceremony_leaving_word_orb = load("res://Effects/CeremonyLeavingWordOrb.tscn").instance()
			Game.current_scene.add_child(ceremony_leaving_word_orb)
			ceremony_leaving_word_orb.init_ceremony_leaving_word_orb(time + 10)
			ceremony_leaving_word_orb.position = center
			released_words += 1
			if released_words > 400:
				phase = 3
	if phase == 3:
		darkness -= delta / 5
		if darkness >= 0:
			$ColorRect.modulate = Color(0, 0, 0, darkness)
			for word in initial_words:
				word.modulate = Color(1, 1, 1, darkness)
		else:
			for word in initial_words:
				word.queue_free()
			_init_phase_4()
	if phase == 4:
		time += delta
		if time > 4:
			finish()

func finish():
	phase = 5
	queue_free()
	SoundPlayer.start_music_upon_entering_map("res://Maps/Chaiyaphum.tscn")
	if Game.can_read_thai:
		yaai.start_quests = ["find_first_words"]
	else:
		yaai.start_quests = ["find_first_letters", "find_first_words"]
	yaai.post_dialog_event = ["can_see_letters", null]
	yaai.interact()
	
