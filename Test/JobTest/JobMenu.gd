extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_SentenceMatching_pressed():
	queue_free()
	var easy_learn = load("res://Test/JobTest/EasyLearn/EasyLearn.tscn").instance()
	Game.current_scene.add_child(easy_learn)


func _on_SentenceTranslation_pressed():
	pass # Replace with function body.


func _on_SpeechRecognition_pressed():
	pass # Replace with function body.


func _on_Quit_pressed():
	queue_free()
	Game.is_frozen = false
