extends Node

func _ready():
	for letter_node in $YSort/Letters.get_children():
		var letter_id = letter_node.id
		var letter = Game.letters[str(letter_id)]
		if letter_id in Game.known_letters or not letter in Game.letters_we_look_for:
			letter_node.modulate = Color(1, 1, 1, 0.3)
