extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var quest

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func init_quest_display(quest_id):
	quest = Quests.quests[quest_id]
	update_display()
	
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
