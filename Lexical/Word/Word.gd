extends Node

export var id = 0
var word
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
	word = Game.words[str(id)]
	$Label.text = word["th"]

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
	
func starts_disappearing():
	is_disappearing = true

func interact(player):
	player.animationState.travel("Idle")
	player.velocity = Vector2.ZERO
	Game.start_test("res://Test/TestGuessMeaning.tscn", id, self)

func _on_Area2D_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if body == Game.player:
		Game.loses_focus(self)
