extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for letter_node in $YSort/Letters.get_children():
		var letter_id = letter_node.id
		var letter = Game.letters[str(letter_id)]
#		print(letter["th"])
#		print("   letter_id in Game.known_letters ", letter_id in Game.known_letters)
#		print("   not letter in Game.letters_we_look_for ", not letter in Game.letters_we_look_for)
		if letter_id in Game.known_letters or not letter in Game.letters_we_look_for:
			letter_node.modulate = Color(1, 1, 1, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
