extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var shown_quest_ids = []

# Called when the node enters the scene tree for the first time.
func _ready():
	update()

func update():
	for quest_id in Quests.quests:
		var quest = Quests.quests[quest_id]
		if quest.status == Quests.IN_PROGRESS:
			shown_quest_ids.append(quest.id)
			$MenuButton.get_popup().add_item(quest.name)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
