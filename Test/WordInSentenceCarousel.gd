extends Node2D

var width = 0
var height = 0
var is_main_word
var word = null

func init(word_id, _is_main_word):
	word = Game.words[str(word_id)]
	var text = word["th"]
	is_main_word = _is_main_word
	$Label.text = text
	width = $Label.get_minimum_size()[0]
	height = $Label.get_minimum_size()[1]
	
	
	# Set collisionShape
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(width/2, height/2))
	$Area2D/CollisionShape2D.set_shape(shape)
	$Area2D/CollisionShape2D.position = Vector2(width/2, height/2)
	
	# Set main ColorRect
	$ColorRect.set_size(Vector2(width, height))
	if is_main_word:
		$ColorRect.color = Color(1, 0.7, 0.7, 1)
	elif word["id"] in Game.known_words:
		$ColorRect.color = Color(0.7, 1, 0.7, 1)
	else:
		$ColorRect.hide()
	
	# Set popup
	if word_id in Game.known_words:
		$Popup/Label.text = word["en"]
	else:
		$Popup/Label.text = "Unknown meaning"
	$Popup/Label.hide()

func _on_Area2D_mouse_entered():
	$ColorRect.show()
	$Popup/Label.show()
	$Popup.position = Vector2(0, 20)
	$ColorRect.color = Color(1, 0.5, 1, 1)

func _on_Area2D_mouse_exited():
	$Popup/Label.hide()
	if is_main_word:
		$ColorRect.color = Color(1, 0.7, 0.7, 1)
	elif word["id"] in Game.known_words:
		$ColorRect.color = Color(0.7, 1, 0.7, 1)
	else:
		$ColorRect.hide()
