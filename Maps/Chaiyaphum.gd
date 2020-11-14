extends Node

var is_blackening = false
var alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.events["has_gone_to_rock"]:
		$YSort/NPCs/Yaai.position = Vector2(202.29, 654.29)
		$YSort/NPCs/Yaai.direction = "right"
	elif Events.events["has_finished_the_letter_world_the_first_time"]:
		Events.events["has_gone_to_rock"] = true
		Game.player.can_interact = false
		Game.can_move = false
		$YSort/NPCs/Yaai.position = Vector2(207.81, 513.20)
		$YSort/NPCs/Yaai.dialog = [
			"Yaai: Welcome back, [Name].",
			"Yaai: You can always go back to your Memory Palace using the F key.",
			"Yaai: For now, follow me into the forest.",
		]
		$YSort/NPCs/Yaai.post_dialog_event = ["yaai_walks_to", [[
			Vector2(285.5, 561.6),
			Vector2(247, 619.5),
			Vector2(199, 652.5),
			Vector2(205, 655.57),
		]]]
		$YSort/NPCs/Yaai.call_deferred("interact")
	elif Events.events["yaai_went_to_forest_entrance"]:
		$YSort/NPCs/Yaai.position = Vector2(207.81, 513.20)
	elif Events.events["talked_to_yaai_for_the_first_time"]:
		$YSort/NPCs/Yaai.position = Vector2(490, 260)

func blackens():
	is_blackening = true
	$CanvasLayer/BlackFadeOut.modulate = Color(1, 1, 1, 0)
	$CanvasLayer/BlackFadeOut.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_blackening:
		alpha += delta
		$CanvasLayer/BlackFadeOut.modulate = Color(1, 1, 1, alpha)

func _on_Area2D5_body_entered(body):
	# Blocker 1
	if body == Game.player:
		if not Events.events["talked_to_yaai_for_the_first_time"]:
			Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"[Name]: I should talk to my grandmother first..."
			]
			Game.current_dialog.init(dialog, self, null, false)
			Game.player.stop_walking()
			get_tree().current_scene.add_child(Game.current_dialog)
			Game.player.forced_toward(Vector2(553, 442))

func _on_Area2D_body_entered(body):
	# Blocker 2
	if body == Game.player:
		if not Events.events["yaai_explains_rock"]:
			Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"[Name]: I shouldn't go there now..."
			]
			Game.current_dialog.init(dialog, self, null, false)
			Game.player.stop_walking()
			get_tree().current_scene.add_child(Game.current_dialog)
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
#				"Yaai: you will forget everything you know of the Thai language and you’ll have to learn Thai again from scratch.",
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

func _on_Area2D3_body_entered(body):
	# Player enters near the rock
	if body == Game.player:
#		print('has_gone_to_rock', Events.events["has_gone_to_rock"])
		if Events.events["has_gone_to_rock"] and not Events.events["yaai_explains_rock"]:
			Events.events["yaai_explains_rock"] = true
			$YSort/NPCs/Yaai.dialog = [
				"Yaai: [Name], you see the sentence written here?",
				"Yaai: This will be your first sentence since you've restarted to learn Thai!",
				"Yaai: This sentence means \"Thai people are good people\" - don't ask me why.",
				"Yaai: Sentences like this will help you understand the meaning of words, you should write it in your notebook.",
			]
			$YSort/NPCs/Yaai.post_dialog_event = ["learns_first_sentence", $YSort/NPCs/Yaai]
			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
			$YSort/NPCs/Yaai.interact()

func _on_Area2D6_body_entered(body):
	if not Events.events.yaai_has_given_last_warning_before_forest and Events.events.yaai_explains_rock:
		Events.events.yaai_has_given_last_warning_before_forest = true
		$YSort/NPCs/Yaai.dialog = [
			"Yaai: Well done [Name]!",
			"Yaai: Now, your test will be to guess the meannig of all words you will find deeper in the forest.",
			"Yaai: I believe four types of Spells live there.",
			"Yaai: Good luck, I'll watch you from here.",
			]
		$YSort/NPCs/Yaai.interact()
