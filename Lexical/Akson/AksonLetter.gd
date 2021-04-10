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
	$SameButWithOrangeContour.text = id
	set_letter()
	is_known = int(letter_id) in Game.known_letters
	$SameButWithBlueContour.hide()
	if not is_known:
		$SameButWithOrangeContour.hide()

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
#	Game.start_test("res://Test/Letter/TestWordFromSound.tscn", letter_id, self)

func _process(delta):
	if is_hovered:
		time += delta * blinking_speed
		var alpha = (1 + sin(time)) / 2 
		$SameButWithBlueContour.modulate = Color(1, 1, 1, alpha)

func _on_Button_mouse_entered():
	SoundPlayer.play_sound("res://Sounds/Effects/select.wav", 0)
	if Game.current_dialog or Game.active_letter_test:
		return
	is_hovered = true
	$SameButWithBlueContour.show()
	$SameButWithBlueContour.modulate = Color(1, 1, 1, 1)
	time = 0

func _on_Button_mouse_exited():
	if Game.current_dialog or Game.active_letter_test:
		return
	$SameButWithBlueContour.hide()
	is_hovered = false

func starts_disappearing():
	# Actually it won't disappear, it will become blue I guess
	is_hovered = false
	is_known = true
	$SameButWithOrangeContour.show()
	$SameButWithOrangeContour.modulate = Color(1, 1, 1, 1)
	emit_signal("akson_letter_learnt", id)

func show_letter_page():
	var letter_page = load("res://Lexical/Letter/LetterPage.tscn").instance()
	Game.letter_page = letter_page
#	get_tree().current_scene.add_child(letter_page)
	get_tree().get_root().add_child(letter_page)
	letter_page.init_letter_page(letter_id)

func _on_Button_pressed():
	if Game.current_dialog or Game.active_letter_test or Game.letter_page:
		return
	if is_known:
		show_letter_page()
	else:
#		starts_disappearing()  # use this for testing, but comment it when playing
		start_letter_test()

func start_letter_test():
	is_hovered = false
	$SameButWithBlueContour.hide()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(get_introduction(), self, post_dialog_event, true, id)
	print('Game.current_scene ', Game.current_scene.name)
#	Game.current_scene.add_child(Game.current_dialog)
#	self.add_child(Game.current_dialog)
	Game.akson.add_child(Game.current_dialog)
	if pre_dialog_event:
		Events.execute(pre_dialog_event[0], pre_dialog_event[1])

func _input(_event):
	if Game.letter_page:
		return
	if is_hovered and Input.is_action_just_pressed("interact"):
		get_tree().set_input_as_handled()
		_on_Button_pressed()

