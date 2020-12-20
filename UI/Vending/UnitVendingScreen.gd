extends CanvasLayer

var sold_entity
var price
var entity_type
var entity_id

func _ready():
	pass # Replace with function body.

func init_unit_vending_screen(_sold_entity, _price, _entity_type, _entity_id):
	sold_entity = _sold_entity
	price = _price
	entity_type = _entity_type
	entity_id = _entity_id
	$Price.text = "฿" + str(price)
	update_entity_name()
	update_money()
	maybe_grey_buy_button()
	update_amount_in_bag()

func update_entity_name():
	if entity_type == "letter":
		$EntityName.text = tr("_letter_") + Game.letters[str(entity_id)].th

func maybe_grey_buy_button():
	if Game.money < price:
		$Buy.disabled = true
	else:
		$Buy.disabled = false

func update_money():
	$YourMoney.text = tr("_your_money") + "฿" + str(Game.money)

func update_amount_in_bag():
	var quantity = 0
	if entity_type == "letter":
		quantity = Game.letters[str(entity_id)]["in_bag"]
	$InBag.text = tr("_in_bag") + str(quantity)

func increase_amount_in_bag():
	if entity_type == "letter":
		Game.letters[str(entity_id)]["in_bag"] += 1
		Events.events.has_possessed_a_letter = true
	update_amount_in_bag()

func _on_Button_pressed():
	queue_free()

func _on_Buy_pressed():
	Money.spends_money(price)
	increase_amount_in_bag()
	update_money()
