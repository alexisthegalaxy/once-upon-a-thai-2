
extends Node2D

export(int) var sentence_id = 196
export(bool) var is_translated = false
export var style = "wood"
export var size = "medium"

var alpha = 0
var time = 0

func _ready():
	$WoodenSentenceSign.hide()
	if size == "small":
		$MediumCollision.disabled = false
		if style == "wood":	
			$SmallWoodenSentenceSign.show()
		else:
			$SmallStoneSentenceSign.show()
	else:
		$SmallCollision.disabled = false
		if style == "wood":
			$WoodenSentenceSign.show()
		else:
			$StoneSentenceSign.show()
	if str(sentence_id) in Game.sentences:
		var sentence = Game.sentences[str(sentence_id)]
		var text = sentence["th"].replace("_", "")
		$Label.text = text
		$BlinkingLabel.text = text
		$Sentence.id = sentence_id
		$Sentence.is_translated = is_translated
	else:
		$Label.text = "..."
		$BlinkingLabel.text = "..."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not sentence_id in Game.known_sentences:
		time += delta
		alpha = cos(time * 2) / 2 + 0.5
		$BlinkingLabel.modulate = Color(1, 1, 1, alpha)
	else:
		$BlinkingLabel.hide()
