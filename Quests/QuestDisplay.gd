extends Node2D

var quest
var quest_id
var goal_location
var hovered_buttons = false

func find_npc_with_that_quest():
	var ysort = Game.current_scene.get_node("YSort")
	if not ysort:
		return
	var npcs = ysort.get_node("NPCs")
	if not npcs:
		return
	for npc in npcs.get_children():
		if quest_id in npc.finish_quests:
			return npc

func find_quest_location():
	if quest.status == Quests.FINISHED:
		var npc = find_npc_with_that_quest()
		if npc:
			return npc.position
		else:
			var map_locations = Game.current_scene.get_node("Locations")
			if not map_locations:
				return
			var goal = map_locations.get_node(quest_id+'_finished')
			if not goal:
				return
			return goal.position
	elif quest.status == Quests.IN_PROGRESS:
		var map_locations = Game.current_scene.get_node("Locations")
		if not map_locations:
			return
		var goal = map_locations.get_node(quest_id)
		if not goal:
			return
		return goal.position

func init_quest_display(_quest_id):
	quest_id = _quest_id
	quest = Quests.quests[quest_id]
	update_display()
	goal_location = find_quest_location()
	$QuestCompass.init_quest_compass(goal_location)
	
func update_display():
	var lo = TranslationServer.get_locale()
	$Title.text = quest[lo + "_name"]
	
	if quest.counter_max > 1:
		$Counter.text = quest[lo + "_counter_name"] + ": " + str(quest.counter) + " / " + str(quest.counter_max)
	else:
		$Counter.hide()
	if quest.status == Quests.FINISHED:
		$Description.text = quest[lo + "_end_description"]
		$green_check_mark.show()
	else:
		$Description.text = quest[lo + "_description"]
		$green_check_mark.hide()

func _on_CloseButton_pressed():
	hovered_buttons = false
	hide()

func _on_CloseButton_mouse_entered():
	hovered_buttons = true

func _on_CloseButton_mouse_exited():
	hovered_buttons = false
