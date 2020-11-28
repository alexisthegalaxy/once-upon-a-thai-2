extends CanvasLayer


var shown_quest_ids = []
var is_showing_quests = false

func _ready():
	$Button.hide()
	$Quests.hide()
	if not "LexicalWorld" in Game.current_map_name:
		update()

func update():
	var number_of_active_quests = 0
	
	for quest_id in Quests.quests:
		var quest = Quests.quests[quest_id]
		if quest.status in [Quests.IN_PROGRESS, Quests.FINISHED]:
			number_of_active_quests += 1
			if number_of_active_quests == 1:
				$Quests/QuestDisplay1.init_quest_display(quest_id)
				$Quests/QuestDisplay1.show()
			if number_of_active_quests == 2:
				$Quests/QuestDisplay2.init_quest_display(quest_id)
				$Quests/QuestDisplay2.show()
			shown_quest_ids.append(quest.id)
	var button_text = tr("_active_quests") + " (" + str(number_of_active_quests) + ")"
	if number_of_active_quests > 0:
		$Button.text = button_text
		$Button.show()
	else:
		$Quests.hide()
		$Button.hide()
		is_showing_quests = false

func _on_item_pressed(id):
	print($MenuButton.get_popup().get_item_text(id), " pressed")

func _on_Button_pressed():
	$Button.release_focus()
	is_showing_quests = not is_showing_quests
	if is_showing_quests:
		$Quests.show()
	else:
		$Quests.hide()
