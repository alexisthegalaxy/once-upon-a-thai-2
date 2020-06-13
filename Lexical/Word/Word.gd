extends Node

export var id = 0
var word
export var thai = ""
export var definition = ""
var is_disappearing = false
var ratio = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal word_area_entered

# Called when the node enters the scene tree for the first time.
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
	

func _on_Area2D_body_entered(_body):
	if _body != self:
		emit_signal('word_area_entered', id)
		is_disappearing = true
