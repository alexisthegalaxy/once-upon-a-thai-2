extends StaticBody2D

export var id = 0
var letter
var is_disappearing = false
var ratio = 1
var wobbles = true
var wobbling_time = 0
var y = 0
export var display_name = ""

# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

func _ready():
	y = self.position.y
	letter = Game.letters[str(id)]
	display_name = letter["th"]
	$Label.text = letter["th"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wobbles:
		wobbling_time += delta
		var wobbling_delta = cos(wobbling_time) * 3
		self.position.y = y + wobbling_delta

	if is_disappearing:
		ratio -= 3 * delta
		self.scale.x = ratio
		self.scale.y = ratio
		if ratio <= 0:
			queue_free()
			if len(Game.known_words) == 4:
				Game.pop_victory_screen()

func get_introduction():
	var introduction_key = TranslationServer.get_locale() + "_introduction"
	if introduction_key in letter:
		return letter[introduction_key]
	else:
		return ["Hey [Name], I'm the " + letter[TranslationServer.get_locale()] + " sound."]

func interact():
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(get_introduction(), self, post_dialog_event, true, null)
	Game.player.stop_walking()
	Game.current_scene.add_child(Game.current_dialog)
	if pre_dialog_event:
		Events.execute(pre_dialog_event[0], pre_dialog_event[1])

func starts_disappearing():
	is_disappearing = true

func dialog_ended():
#	print("starts test!")
	# first test
	Game.start_test("res://Test/Letter/TestPronFromThaiLet.tscn", id, self)
	# final test - just for debugging - keep commented out
#	Game.start_test("res://Test/Letter/TestWordFromSound.tscn", id, self)
#	wobbles = false

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)
