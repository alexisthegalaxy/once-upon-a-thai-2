extends Node2D

export var id = "โ-ะ"
var is_hovered = false
const blinking_speed = 15
var time = 0
var letter = {}
var letter_id = 1
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []
var is_known = false
signal akson_letter_learnt

func _ready():
	$Label.text = id
	$SameButWithBlueContour.text = id
	set_letter()
	is_known = letter_id in Game.known_letters
	if not is_known:
		$SameButWithBlueContour.hide()

func set_letter():
	for game_letter_id in Game.letters:
		var game_letter = Game.letters[game_letter_id]
		if game_letter.th.replace('-', '') == id.replace('-', ''):
			letter = game_letter
			letter_id = game_letter_id
			return
	print('the following letter is missing in letters.json: ', id, "   .")
	assert(false)

func get_introduction():
	var introduction_key = TranslationServer.get_locale() + "_introduction"
	if introduction_key in letter:
		return letter[introduction_key]
	else:
		return ["Hey [Name], I'm the " + letter[TranslationServer.get_locale()] + " sound."]

func dialog_ended():
	# first test
	Game.start_test("res://Test/Letter/TestPronFromThaiLet.tscn", letter_id, self)
	# final test - just for debugging - keep commented out
	# Game.start_test("res://Test/Letter/TestWordFromSound.tscn", id, self)

func _process(delta):
	if is_known:
		return
	if is_hovered:
		time += delta * blinking_speed
		var alpha = (1 + sin(time)) / 2 
		$SameButWithBlueContour.modulate = Color(1, 1, 1, alpha)

func _on_Button_mouse_entered():
	if Game.is_frozen or Game.current_dialog or Game.active_test:
		return
	is_hovered = true
	$SameButWithBlueContour.show()
	$SameButWithBlueContour.modulate = Color(1, 1, 1, 1)
	time = 0

func _on_Button_mouse_exited():
	if Game.is_frozen or Game.current_dialog or Game.active_test:
		return
	$SameButWithBlueContour.hide()
	is_hovered = false

func starts_disappearing():
	# Actually it won't disappear, it will become blue I guess
	is_hovered = false
	is_known = true
	$SameButWithBlueContour.show()
	$SameButWithBlueContour.modulate = Color(1, 1, 1, 1)
	emit_signal("akson_letter_learnt", id)

func _on_Button_pressed():
	if Game.is_frozen or Game.current_dialog or Game.active_test:
		return
	starts_disappearing()
#	is_hovered = false
#	$SameButWithBlueContour.hide()
#	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
#	Game.current_dialog.init_dialog(get_introduction(), self, post_dialog_event, true, null)
##	Game.player.stop_walking()
#	Game.current_scene.add_child(Game.current_dialog)
##	Game.lose_focus(null)
#	if pre_dialog_event:
#		Events.execute(pre_dialog_event[0], pre_dialog_event[1])
