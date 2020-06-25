extends StaticBody2D

export(String) var to_map_name
export(int) var to_x
export(int) var to_y
export(Texture) var sprite = preload("res://World/LexicalWorld/mc_door.png")
export var leads_to = "This door leads back to the Lexical Nexus."
export var leads_to_letters = []  # a list of ids
var time = 0
var door_text = ""

func _ready():
	$Sprite.set_texture(sprite)
	if leads_to_letters:
		for letter_we_look_for in Game.letters_we_look_for:
			if letter_we_look_for["id"] in leads_to_letters:
				door_text += letter_we_look_for["th"] + "  "
		if door_text:
			$Node2D/Label.text = door_text
		else:
			$Node2D.hide()
	else:
		$Node2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if door_text:
		time += delta
		var alpha = 0.5 + 0.5 * cos(time * 3)
		$Node2D.modulate = Color(0.5, 1, 1, alpha)
		
func _on_InteractArea_body_entered(body):
	if body == Game.player:
		Game.gains_focus(self)

func _on_InteractArea_body_exited(body):
	if body == Game.player:
		Game.loses_focus(self)

func dialog_option(value):
	if value == 1:
		Game.call_deferred("_deferred_goto_scene", to_map_name, to_x, to_y)

func interact(player):
	var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
	var dialog = [
		leads_to,
		"Do you want to take it? @QYes/No"
	]
	ui_dialog.init(dialog, player, self, null, false)
	player.animationState.travel("Idle")
	player.velocity = Vector2.ZERO
	get_tree().current_scene.add_child(ui_dialog)
