extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(_player):
	player = _player
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func close_hub():
	player.hub.queue_free()
	player.hub = null
	

func _on_Words_pressed():
	var dict = load("res://Lexical/Dict/Dict.tscn").instance()
	player.dict = dict
	close_hub()
	dict.init(player)
	get_tree().current_scene.add_child(dict)


func _on_Letters_pressed():
	var alphabet = load("res://Lexical/Alphabet/Alphabet.tscn").instance()
	player.alphabet = alphabet
	close_hub()
	alphabet.init(player)
	get_tree().current_scene.add_child(alphabet)
