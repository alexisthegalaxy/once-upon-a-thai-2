extends Node2D

var sprite_path = "res://Npcs/sprites/main_A.png"
var state = "stand"  # can be "stand" or "walk"
export var index = "A"
export var is_selected = false
signal selected_character

func make_animation(animation_name, key_1, key_2, key_3, key_4):
	var animation = Animation.new()
	animation.add_track(Animation.TYPE_VALUE)
	animation.length = 0.8
	var path = String($Sprite.get_path()) + ":frame"
	animation.track_set_path(0, path)
	animation.track_insert_key(0, 0.0, key_1)
	animation.track_insert_key(0, 0.2, key_2)
	animation.track_insert_key(0, 0.4, key_3)
	animation.track_insert_key(0, 0.6, key_4)
	animation.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	animation.loop = 1
	$AnimationPlayer.add_animation(animation_name, animation)
	$AnimationPlayer.set_current_animation(animation_name)

func make_animations():
	make_animation("walk_down", 1, 0, 2, 0)
	make_animation("stand_down", 0, 0, 0, 0)

func update():
	$AnimationPlayer.play(state  + "_down")
	if is_selected:
		$Background.modulate = Color(1, 1, 1, 1)
	else:
		$Background.modulate = Color(1, 1, 1, 0.4)

func set_selected(value):
	is_selected = value
	update()

func init(init_menu):
	sprite_path = "res://Npcs/sprites/main_" + index + ".png"
	var _e = self.connect("selected_character", init_menu, "on_selected_character", [])
	$Sprite.texture = load(sprite_path)
	$Sprite.vframes = 1
	$Sprite.hframes = 12
	make_animations()
	update()

func _on_Area2D_mouse_entered():
	state = "walk"
	update()

func _on_Area2D_mouse_exited():
	state = "stand"
	update()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("selected_character")
		is_selected = true
		Game.player_sprite_path = sprite_path
		update()
