extends Node

func spends_money(amount):
	Events.events.money_is_visible = true
	Game.money -= amount
	SoundPlayer.play_sound("res://Sounds/Effects/money.wav", -15)
	Game.main_ui.update_main_ui_money_display()

func earn_money(amount):
	Game.money += amount
	Events.events.money_is_visible = true
	Game.main_ui.update_main_ui_money_display()
