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
	var lo = TranslationServer.get_locale()
	quest = Quests.quests[quest_id]
	$Title.text = quest[lo + "_name"]
	$Description.text = quest[lo + "_description"]
	if quest.counter > 1:
		$Counter.text = quest[lo + "_description"] + ":" + str(quest.counter) + " / " + str(quest.counter_max)
	else:
		$Counter.hide()
