extends Node

var is_blackening = false
var alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.events["yaai_went_to_forest_entrance"]:
		$YSort/NPCs/Yaai.position = Vector2(207.81, 513.20)
	elif Events.events["talked_to_yaai_for_the_first_time"]:
		$YSort/NPCs/Yaai.position = Vector2(490, 260)

func blackens():
	is_blackening = true
	$CanvasLayer/ColorRect.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_blackening:
		alpha += delta
		$CanvasLayer/ColorRect.modulate = Color(1, 1, 1, alpha)

func _on_Area2D5_body_entered(body):
	# Blocker 1
	if body == Game.player:
		if not Events.events["talked_to_yaai_for_the_first_time"]:
			var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"[Name]: I should talk to my grandmother first..."
			]
			ui_dialog.init(dialog, self, null, false)
			Game.player.stop_walking()
			get_tree().current_scene.add_child(ui_dialog)
			Game.player.forced_toward(Vector2(553, 442))

func _on_Area2D_body_entered(body):
	# Blocker 2
	if body == Game.player:
		if not Events.events["ceremony_finished"]:
			var ui_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"[Name]: I shouldn't go there now..."
			]
			ui_dialog.init(dialog, self, null, false)
			Game.player.stop_walking()
			get_tree().current_scene.add_child(ui_dialog)
			Game.player.forced_toward(Vector2(541, 240))

func _on_Area2D2_body_entered(body):
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["yaai_went_to_forest_entrance"]:
			Events.events["yaai_went_to_forest_entrance"] = true
			$YSort/NPCs/Yaai.will_go_to = [
				Vector2(430.30, 257.27),
				Vector2(388.46, 288.40),
				Vector2(330.59, 264.30),
				Vector2(275.59, 273.01),
				Vector2(207.96, 326.66),
				Vector2(171.95, 421.33),
				Vector2(128.83, 516.44),
				Vector2(207.81, 504.86),
				Vector2(207.81, 513.20),
			]
			$YSort/NPCs/Yaai.starts_going_toward($YSort/NPCs/Yaai.will_go_to[0])


func _on_Area2D4_body_entered(body):
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["ceremony_started"]:
			Events.events["ceremony_started"] = true
			$YSort/NPCs/Yaai.dialog = [
#				"Yaai: Here's the place, and now is the time.",
#				"Yaai: Let's start your shamanic initiation.",
#				"Yaai: Once you drink this potion, you will gain power over spirits and spells,",
#				"Yaai: But there is a cost:",
#				"Yaai: you will forget all you know of the Thai language and you’ll have to learn Thai again from scratch.",
#				"Yaai: You trade your fluency in your mother tongue for power over the spirit world.",
#				"Yaai: Are you ready?",
				"[Name] drinks the potion.",
			]
			$YSort/NPCs/Yaai.post_dialog_event = ["enters_lexical_world", null]
			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
			$YSort/NPCs/Yaai.interact()
			Game.letters_we_look_for = []
			for letter_id in Game.initial_letters:
				Game.letters_we_look_for.append(Game.letters[str(letter_id)])
