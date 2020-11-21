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
		quests[quest_id].status = NOT_STARTED  # should be NOT_STARTED
		quests[quest_id].id = quest_id
		quests[quest_id].counter = 0
	print('questsˀ')
	for quest_id in quests:
		print('------------------------')
		print(quests[quest_id])

func start_quest(quest_id):
	print('we start the quest ', quest_id)
	quests[quest_id].status = IN_PROGRESS
	Game.player.update_quest_display()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
