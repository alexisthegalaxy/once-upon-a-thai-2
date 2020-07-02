extends StaticBody2D

export var id = 0
var letter
var is_disappearing = false
var ratio = 1
var wobbles = true
var wobbling_time = 0
var y = 0

# events are an array that contains first the event name, then the array of parameters
export(Array) var pre_dialog_event = []
export(Array) var post_dialog_event = []

func _ready():
	y = self.position.y
	letter = Game.letters[str(id)]
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
	if "introduction" in letter:
		return letter["introduction"]
	else:
		return [letter["th"] + ": Hey [Name], I'm the " + letter["en"] + " sound."]

func interact(player):
	print('interact!')
	var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
	
	ui_dialog.init(get_introduction(), self, post_dialog_event, true)
	player.stop_walking()
	get_tree().current_scene.add_child(ui_dialog)
	if pre_dialog_event:
		Events.execute(pre_dialog_event[0], pre_dialog_event[1])

func starts_disappearing():
	is_disappearing = true

func dialog_ended():
	Game.start_test("res://Test/Letter/TestPronFromThaiLet.tscn", id, self)
#	Game.start_test("res://Test/Letter/TestWordFromSound.tscn", id, self)
#	wobbles = false

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.loses_focus(self)
