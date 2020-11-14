extends CanvasLayer

const NUMBER_OF_WORDS_PER_LINE = 7
const NUMBER_OF_DISPLAYED_LINES = 6
var displayed_words = []
var y_bottom = 0
func s_x(x):
	return x * 32 + 28

func s_y(y):
	return y * 32 + 16

func sort_on_teaching_order(a, b):
	return a["teaching_order"] < b["teaching_order"]

func get_words_with_order():
	var words_with_order = []
	for word_id in Game.words:
		var word = Game.words[word_id]
		if int(word["teaching_order"]) > -1:
			words_with_order.append(word)
	return words_with_order
	
func _input(event) -> void:
	if event is InputEventPanGesture:
		var y_delta = -event.delta.y * 10
		if y_bottom >= 0 and y_delta > 0:
			return
		y_bottom = y_bottom + y_delta
		for word in displayed_words:
			word.position.y += y_delta
#	if Input.is_action_just_pressed("ui_page_down"):
#		print('ui_page_down')
#	if Input.is_action_just_pressed("ui_page_up"):
#		print('ui_page_up')

func init():
	var DictWord = load("res://Lexical/Dict/DictWord.tscn")
	var x = 0
	var y = 0
	var varying_y = 3
	var words_with_order = get_words_with_order()
	words_with_order.sort_custom(self, "sort_on_teaching_order")
	
	for word in words_with_order:
		var dict_word = DictWord.instance()
		$Control.add_child(dict_word)
		displayed_words.append(dict_word)
		dict_word.init_dict_word(word["id"])
		dict_word.position = Vector2(s_x(x), s_y(y) + varying_y)
		varying_y = -varying_y
		x += 1
		if x > NUMBER_OF_WORDS_PER_LINE:
			y += 1
			x = 0
	
