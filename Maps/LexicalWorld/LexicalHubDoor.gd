extends StaticBody2D

export(String) var to_map_name
export(int) var to_x
export(int) var to_y
export(Texture) var sprite = preload("res://World/LexicalWorld/mc_door.png")
export var leads_to = "This door leads back to the Lexical Nexus."
export var leads_to_letters = []  # a list of ids
var time = 0
var door_text = ""

func init_letters():
	if leads_to_letters:
		door_text = ""
		for letter_we_look_for in Game.letters_we_look_for:
			if letter_we_look_for["id"] in leads_to_letters:
				if not letter_we_look_for["id"] in Game.known_letters:
					door_text += letter_we_look_for["th"] + "  "
		if door_text:
			$Node2D.show()
			$Node2D/Label.text = door_text
		else:
			$Node2D.hide()
	else:
		$Node2D.hide()

func _ready():
	$Sprite.set_texture(sprite)
	init_letters()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if door_text:
		time += delta
		var alpha = 0.5 + 0.5 * cos(time * 3)
		$Node2D.modulate = Color(0, 1, 1, alpha)

func _on_InteractArea_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_InteractArea_body_exited(body):
	if body == Game.player:
		Game.lose_focus(self)

func dialog_option(parameters):
	var value = parameters[1]
	if value == 1:
		Game.this_letter_world_has_letters = leads_to_letters
		Game.call_deferred("_deferred_goto_scene", to_map_name, to_x, to_y)
		SoundPlayer.play_sound("res://Sounds/door.wav")

func interact():
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	var dialog = [
		leads_to + " \nDo you want to take it? @QYes/No"
	]
	Game.current_dialog.init_dialog(dialog, self, null, false)
	Game.player.stop_walking()
	Game.current_scene.add_child(Game.current_dialog)
