extends Node2D

var teal_tint = 0
var time = 0
var mouse_in = false
var letter_ids = []

func init(_letter_ids):
	letter_ids = _letter_ids

func _process(delta):
	if mouse_in:
		$Sprite.modulate = Color(0, 1, 1, 1)
	else:
		time += delta
		teal_tint = 0.5 + 0.5 * cos(time * 15)
		$Sprite.modulate = Color(teal_tint, 1, 1, 1)

func _on_Area2D_mouse_entered():
	mouse_in = true

func _on_Area2D_mouse_exited():
	mouse_in = false

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		for letter_id in letter_ids:
			Game.letters_we_look_for.append(Game.letters[str(letter_id)])
		
#		var timer = Timer.new()
#		timer.connect("timeout", Events, "immediately_enters_lexical_world")
#		Events.immediately_enters_lexical_world()
		Events.enters_lexical_world(null)
		Game.active_test.queue_free()
		print('letter_ids')
		print(letter_ids)
#		get_tree().current_scene.blackens()
		
#		Game.can_move = false
		
#		timer.set_wait_time(1)
#		timer.set_one_shot(true)
#		timer.autostart = true
#		add_child(timer)
#		timer.start()
		
