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
	if is_disappearing:
		ratio -= 3 * delta
		self.scale.x = ratio
		self.scale.y = ratio
		if ratio <= 0:
			queue_free()

func interact():
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog([
		tr("_you_found_letter_s_you_put_it_in_bag_come_in_handy_later") % letter["th"]
	], self, null, null, null)
	Game.player.stop_walking()
	Game.current_scene.add_child(Game.current_dialog)
	is_disappearing = true
#	Game.collected_letters.append(letter["id"])
	Game.letters[str(id)]["in_bag"] += 1
#	if pre_dialog_event:
#		Events.execute(pre_dialog_event[0], pre_dialog_event[1])

func starts_disappearing():
	is_disappearing = true

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)
