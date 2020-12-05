extends Node2D

var entity_type
var entity_id
var entity
var price

func _ready():
	pass # Replace with function body.

func init_vending_screen_unit(_entity_identifier):
	var split_identifier = _entity_identifier.split("-")
	entity_type = split_identifier[0]
	entity_id = split_identifier[1]
	price = int(split_identifier[2])
	if entity_type == "letter":
		entity = Game.letters[entity_id]
		$Label.text = tr("_letter_") + entity.th
	else:
		$Label.text = "Unknown " + entity_type
	$Price.text = "฿" + str(price)

func _on_Button_pressed():
	var UnitVendingScreen = load("res://UI/Vending/UnitVendingScreen.tscn")
	var unit_vending_screen = UnitVendingScreen.instance()
	unit_vending_screen.init_unit_vending_screen(entity, price, entity_type, entity_id)
	Game.vending_screen.add_child(unit_vending_screen)
