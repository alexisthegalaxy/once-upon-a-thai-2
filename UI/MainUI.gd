extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Letters._init_main_ui_button("_see_letters")
	$Words._init_main_ui_button("_see_words")
	$Sentences._init_main_ui_button("_see_sentences")
	$GoLetterWorld._init_main_ui_button("_go_to_letter_world")
	$Quests._init_main_ui_button("_quests")
	$UseSpell._init_main_ui_button("_use_spell")
	$MakeSpell._init_main_ui_button("_make_spell")

func update_main_ui():
	if Game.known_letters:
		$Letters.show()
	else:
		$Letters.hide()
	if Game.known_words:
		$Words.show()
	else:
		$Words.hide()
	if Game.known_sentences:
		$Sentences.show()
	else:
		$Sentences.hide()
	if Events.events.money_is_visible:
		$Money.show()
	else:
		$Money.hide()
	if Events.events.has_finished_the_letter_world_the_first_time:
		$GoLetterWorld.show()
		if Game.is_in_letter_world():
			$GoLetterWorld/Button.text = "   " + tr("_go_back_to_the_material_world")
		else:
			$GoLetterWorld/Button.text = "   " + tr("_go_to_letter_world")
	else:
		$GoLetterWorld.hide()
	if Game.following_spells:
		$UseSpell.show()
	else:
		$UseSpell.hide()
	if Events.events.has_possessed_a_letter:
		$MakeSpell.show()
	else:
		$MakeSpell.hide()
	if Events.events.has_had_a_quest:
		$Quests.show()
	else:
		$Quests.hide()

func update_quests_display():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
