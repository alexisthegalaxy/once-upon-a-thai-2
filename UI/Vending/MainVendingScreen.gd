extends CanvasLayer

const INITIAL_X = 35
const INITIAL_Y = 53
const DELTA_Y = 50
const DELTA_X = 50
const ENTITIES_PER_ROW = 6
var sold_entities = ["letter-14", "item-0"]
var VendingScreenUnit = load("res://UI/Vending/VendingScreenUnit.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init_vending_screen(_sold_entities):
	if not Events.events.money_is_visible:
		Events.events.money_is_visible = true
		Game.main_ui.update_main_ui_money_display()
	print("_sold_entities ", _sold_entities)
	sold_entities = _sold_entities
	var index = 0
	for sold_entity in sold_entities:
		var unit = VendingScreenUnit.instance()
		unit.init_vending_screen_unit(sold_entity)
		unit.position = get_position_from_index(index)
		self.add_child(unit)
		index += 1

func get_position_from_index(index):
	var y = INITIAL_Y + int(index / ENTITIES_PER_ROW) * DELTA_Y
	var x = INITIAL_X + int(index % ENTITIES_PER_ROW) * DELTA_X
	return Vector2(x, y)

