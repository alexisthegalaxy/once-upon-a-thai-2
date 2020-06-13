extends CanvasLayer

const NUMBER_OF_WORDS_PER_LINE = 7
const NUMBER_OF_DISPLAYED_LINES = 6
const NUMBER_OF_WORDS_TO_DISPLAY = NUMBER_OF_WORDS_PER_LINE * NUMBER_OF_DISPLAYED_LINES

func s_x(x):
	return x * 32 + 48

func s_y(y):
	return y * 32 + 32

func init_words():
	var DictWord = load("res://Lexical/Dict/DictWord.tscn")
	var x = 0
	var y = 0
	for i in Game.words:
		var word = Game.words[i]
		i = int(i)
		if i > NUMBER_OF_WORDS_TO_DISPLAY:
			return
		var dict_word = DictWord.instance()
		self.add_child(dict_word)
		dict_word.set_thai(word["th"])
		dict_word.set_known(Game.knows_word(word))
		dict_word.position = Vector2(s_x(x), s_y(y))
		
		x += 1
		if x > NUMBER_OF_WORDS_PER_LINE:
			y += 1
			x = 0

func init(_player):
	init_words()
	
