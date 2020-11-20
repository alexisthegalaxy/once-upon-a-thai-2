extends Node

# the status of a quest can be in these states:
enum {
	NOT_STARTED,
	IN_PROGRESS,
	DONE,
}
var quests = []

# Called when the node enters the scene tree for the first time.
func _ready():
	quests = Game.retrieve_from_json_file("res://Quests/quests.json")
	for quest_id in quests:
		quests[quest_id].status = IN_PROGRESS  # NOT_STARTED
		quests[quest_id].id = quest_id
	print('questsˀ')
	for quest_id in quests:
		print('------------------------')
		print(quests[quest_id])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
