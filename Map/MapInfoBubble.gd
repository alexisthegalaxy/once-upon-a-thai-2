extends Node2D

var province
var player_in_province
var lo = TranslationServer.get_locale()

func _init_map_info_bubble(province_id):
	province = Game.provinces[province_id]
	$Label.text = province[lo]
	$Thai.text = province.th
	var y = 35
	var x = 0
	for word_id in province.words:
		var info_bubble_word = load("res://Map/MapInfoBubbleWord.tscn").instance()
		info_bubble_word.position = Vector2(x, y)
		self.add_child(info_bubble_word)
		info_bubble_word._init_map_info_bubble_word(word_id)
		if x == 40:
			x = 0
			y += 10
		else:
			x = 40

func _process(delta):
#	position = Vector2(100, 100)
#	print(position)
	print(get_global_mouse_position())
#	position = get_global_mouse_position()
#	position = Vector2(1000 * cos(time), 1000 * sin(time * 4))
