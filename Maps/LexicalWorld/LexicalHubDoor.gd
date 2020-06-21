extends StaticBody2D

export(String) var to_map_name
export(int) var to_x
export(int) var to_y
export(Texture) var sprite = preload("res://World/LexicalWorld/mc_door.png")
export var leads_to = "This door leads back to the Lexical Nexus."

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.set_texture(sprite)

func _on_InteractArea_body_entered(body):
	if body == Game.player:
		Game.current_focus = self
		Game.player.can_interact = true

func _on_InteractArea_body_exited(body):
	if body == Game.player:
		if Game.current_focus == self:
			Game.current_focus = null
			Game.player.can_interact = false

func dialog_option(value):
	if value == 1:
		Game.call_deferred("_deferred_goto_scene", to_map_name, to_x, to_y)

func interact(player):
	print('interact with a door...')
	var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
	var dialog = [
		leads_to,
		"Do you want to take it? @QYes/No"
	]
	ui_dialog.init(dialog, player, self, null, false)
	player.animationState.travel("Idle")
	player.velocity = Vector2.ZERO
	get_tree().current_scene.add_child(ui_dialog)
