extends CanvasLayer


var shown_quest_ids = []
var is_showing_quests = false

func _ready():
	$Quests.hide()
	if not Game.is_in_letter_world():
		update_quests_display()

func update_quests_display():
	var number_of_active_quests = 0
	$Quests/QuestDisplay1.hide()
	$Quests/QuestDisplay2.hide()
	$Quests/QuestDisplay3.hide()
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
			if number_of_active_quests == 3:
				$Quests/QuestDisplay3.init_quest_display(quest_id)
				$Quests/QuestDisplay3.show()
			shown_quest_ids.append(quest.id)
	if number_of_active_quests == 0:
		$Quests.hide()
		is_showing_quests = false
	var number_of_quests_display = "(" + str(number_of_active_quests) + ") "
	return number_of_quests_display + tr("_active_quests")

func _press_quests_button():
	if is_showing_quests:
		# If all quests were closed by the user, then we show them again!
		if (not $Quests/QuestDisplay1.is_visible() and not $Quests/QuestDisplay2.is_visible() and not $Quests/QuestDisplay3.is_visible()):
			is_showing_quests = true
		else:
			is_showing_quests = false
	else:
		is_showing_quests = true
	if is_showing_quests:
		open_quest_display()
	else:
		$Quests.hide()

func open_quest_display():
	is_showing_quests = true
	update_quests_display()
	$Quests.show()

func is_hovering_over_buttons():
	return (
		$Quests/QuestDisplay1.hovered_buttons or
		$Quests/QuestDisplay2.hovered_buttons or 
		$Quests/QuestDisplay3.hovered_buttons
	)
