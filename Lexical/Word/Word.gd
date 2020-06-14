extends Node

export var id = 0
var word
var is_disappearing = false
var ratio = 1

signal word_area_entered

func _ready():
	var _e = self.connect("word_area_entered", Game, "_on_word_area_entered", [])
	word = Game.words[str(id)]
	$Label.text = word["th"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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

func _on_Area2D_body_entered(_body):
	if _body == Game.player:
		emit_signal('word_area_entered', id, self)
		# starts_disappearing()
