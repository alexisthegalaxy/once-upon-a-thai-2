extends Node

var is_blackening = false
var alpha = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Events.events.ploy_has_stopped_in_front_of_house:
		$YSort/NPCs/Ploy.queue_free()
		$YSort/Bushes/BushThatWillGetCut.queue_free()
	if Events.events.has_learnt_four_first_words:
		set_events_when_has_learnt_four_first_words()
	if Events.events.has_gone_to_rock:
		$YSort/NPCs/Yaai.position = Vector2(202.29, 654.29)
		$YSort/NPCs/Yaai.direction = "right"
	elif Events.events["has_finished_the_letter_world_the_first_time"]:
		Events.events["has_gone_to_rock"] = true
		Game.player.can_interact = false
		Game.can_move = false
		$YSort/NPCs/Yaai.position = Vector2(207.81, 513.20)
		$YSort/NPCs/Yaai.dialog = [
			"Welcome back, [Name].",
			"You can always go back to your Memory Palace using the F key.",
			"For now, follow me into the forest.",
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
				"I should talk to my grandmother first..."
			]
			Game.current_dialog.init_dialog(dialog, self, null, false)
			Game.player.stop_walking()
			Game.current_scene.add_child(Game.current_dialog)
			Game.player.forced_toward(Vector2(553, 442))

func _on_Area2D_body_entered(body):
	# Blocker 2
	if body == Game.player:
		if not Events.events["yaai_explains_rock"]:
			Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
			var dialog = [
				"I shouldn't go there now..."
			]
			Game.current_dialog.init_dialog(dialog, self, null, false)
			Game.player.stop_walking()
			Game.current_scene.add_child(Game.current_dialog)
			Game.player.forced_toward(Vector2(541, 240))

func _on_Area2D2_body_entered(body):
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["yaai_went_to_forest_entrance"]:
			Events.events["yaai_went_to_forest_entrance"] = true
			$YSort/NPCs/Yaai.will_go_to = [
				Vector2(424.345886, 258.342377),
				Vector2(386.262726, 289.715057),
				Vector2(329.735779, 262.521484),
				Vector2(276.05658, 267.983002),
				Vector2(230.951202, 318.291962),
				Vector2(151.844299, 356.405609),
				Vector2(82.644707, 418.610535),
				Vector2(96.330925, 486.941467),
				Vector2(162.271317, 516.195312),
				Vector2(275.153534, 523.72229)
			]
			$YSort/NPCs/Yaai.starts_going_toward($YSort/NPCs/Yaai.will_go_to[0])

func _on_Area2D4_body_entered(body):
	# Yaai goes to center of forest when we get in
	if body == Game.player:
		if not Events.events["ceremony_started"]:
			Events.events["ceremony_started"] = true
			$YSort/NPCs/Yaai.dialog = [
				"Here's the place, and now is the time.",
				"Let's start your shamanic initiation.",
				"Once you drink this potion, you will gain power over spirits and spells,",
				"But there is a cost:",
				"you will forget everything you know of the Thai language and you’ll have to learn Thai again from scratch.",
				"You trade your fluency in your mother tongue for power over the spirit world.",
				"Are you ready?",
				"[ShowNoName][Name] drinks Yaai's potion.",
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
				"[Name], you see the sentence written here?",
				"This will be your first sentence since you've forgotten Thai!",
				"This sentence means \"Thai people are good people\" - don't ask me why.",
				"Sentences like this will help you understand the meaning of words, you should write it in your notebook.",
			]
			$YSort/NPCs/Yaai.post_dialog_event = ["learns_first_sentence", $YSort/NPCs/Yaai]
			$YSort/NPCs/Yaai.is_walking_towards = []  # to make sure NPC can interact
			$YSort/NPCs/Yaai.interact()

func _on_Area2D6_body_entered(body):
	if not body == Game.player:
		return
	# This is the are athat leads into the first forest.
	# It can be used the first time for Yaai warning,
	# and the second time for Yaai's instruction to go to Chaiyaphum
	if not Events.events.yaai_has_given_last_warning_before_forest and Events.events.yaai_explains_rock:
		Events.events.yaai_has_given_last_warning_before_forest = true
		$YSort/NPCs/Yaai.dialog = [
			"Well done [Name]!",
			"Now, your test will be to guess the meaning of all words you will find deeper in the forest.",
			"I believe four types of Spells live there.",
			"Good luck, I'll watch you from here.",
			]
		$YSort/NPCs/Yaai.post_dialog_event = []
		$YSort/NPCs/Yaai.interact()
		
	if not Events.events.has_learnt_four_first_words:
		if 343 in Game.known_words and 345 in Game.known_words and 207 in Game.known_words and 82 in Game.known_words:
			Events.events.has_learnt_four_first_words = true
			set_events_when_has_learnt_four_first_words()
			$YSort/NPCs/Yaai.interact()

func set_events_when_has_learnt_four_first_words():
	$YSort/NPCs/PetsMom.dialog = [
		"I’m so happy for Pet, his shamanic initiation went well.",
		"He’s in Chaiyaphum now, tell him to drop by if you meet him!"
	]
	$YSort/NPCs/Yaai.dialog = [
		"That's good, [Name], very good!",
		"Now, go to Chaiyaphum, and ask the grandmother of your friend Ploy to carry on with your training.",
		"I have very important issues to solve in the spirit world.",
		"If everything goes well, I'll be seeing you soon, [Name].",
		]
	$YSort/NPCs/Yaai.post_dialog_event = ["npc_disappears_in_white_orb", [$YSort/NPCs/Yaai]]
	$YSort/NPCs/Pet.position = Vector2(557.0, 432.6)

func _on_PetWillWalk_body_entered(body):
	if not body == Game.player:
		return
	if not Events.events.has_learnt_four_first_words:
		return
	if Events.events.has_met_pet:
		return
	$YSort/NPCs/Pet.dialog = [
		"Oh, hey [Name].",
		"What, you finished your initiation?",
		"Tch. It took you long enough. I finished mine thirty minutes ago already.",
		"I’d like to have you as a training partner but I doubt you’ll be able to match my intellect.",
		"I’m guessing you don’t even know how to write a basic word such as \"bpai\". @Qไท/ปไ/ไป/ทไ",
	]
	$YSort/NPCs/Pet.position = Vector2(557.0, 432.6)
	$YSort/NPCs/Pet.will_go_to = [
		Vector2 (519.2, 375.6),
		Vector2(534.0, 254.6),
		Vector2(504.0, 254.6),
	]
	$YSort/NPCs/Pet.starts_going_toward($YSort/NPCs/Pet.will_go_to[0])

func _on_PloyWillCome_body_entered(body):
	if not body == Game.player:
		return
	if not Events.events.has_met_ploy:
		Events.events.has_met_ploy = true
		$YSort/NPCs/Ploy.dialog = [
			"[Name]! How was your shamanic initiation?",
			"Mine went well too! My grandmother has been teaching me super cool stuff!",
			"Look!"
		]
		$YSort/NPCs/Ploy.will_go_to = [
			Vector2(992, 117.146461),
			Vector2(790, 117.146461),
		]
		$YSort/NPCs/Ploy.post_dialog_event = ["ploy_cuts_bush", [$YSort/NPCs/Ploy, $YSort/Bushes/BushThatWillGetCut]]
		$YSort/NPCs/Ploy.starts_going_toward($YSort/NPCs/Ploy.will_go_to[0])

func _on_PloyInFrontOfHouse_body_entered(body):
	if not body == Game.player:
		return
	if Events.events.ploy_has_stopped_in_front_of_house:
		return
	Events.events.ploy_has_stopped_in_front_of_house = true
	$YSort/NPCs/Ploy.is_walking_towards = []
	$YSort/NPCs/Ploy.interact()
