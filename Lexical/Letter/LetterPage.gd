extends CanvasLayer

var letter

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_letter_page(_letter_id):
	letter = Game.letters[str(_letter_id)]
	$Thai.text = letter.th
	$ThaiFont2.text = letter.th
	$English.text = letter.en
	$Mem.text = letter.mem
	if letter.mem == "":
		$MemLabel.hide()
	$TestSoundPlayer.init_sound_player(letter.audio)
	if letter.class in ["LOW", "MID", "HIGH"]:
		$Class.text = letter.class
	else:
		$Class.hide()
		$ClassLabel.hide()

func _on_OkButton_pressed():
	var alphabet = load("res://Lexical/Alphabet/Alphabet.tscn").instance()
	Game.player.alphabet = alphabet
	alphabet.init()
	Game.current_scene.add_child(alphabet)
	Game.player.letter_page = null
	self.queue_free()
