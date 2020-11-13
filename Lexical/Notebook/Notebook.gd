extends CanvasLayer

const NUMBER_OF_SENTENCES_PER_PAGE = 4
const NUMBER_OF_DISPLAYED_LINES = 6
var all_sentences = []
var interactive_sentences = []
var y_bottom = 0
var current_page_index = 0  # a page has 8 sentences, 4 per side
var active_page = "left"
const CENTER_LEFT_PAGE_X = 90 - 15 - 5
const CENTER_RIGHT_PAGE_X = 230 - 15 - 5
const X_TOP_OF_PAGE = 14

func s_x(x):
	return x * 32 + 28

func s_y(y):
	return y * 32 + 16

func get_sentences_for_page(page_index):
	all_sentences = []
	var i = 0
	for sentence_id in Game.known_sentences + Game.seen_sentences:
		if i >= page_index * NUMBER_OF_SENTENCES_PER_PAGE * 2:
			all_sentences.append(Game.sentences[str(sentence_id)])
		if len(all_sentences) >= NUMBER_OF_SENTENCES_PER_PAGE * 2:
			return
		i += 1

func init(page_index):
	get_sentences_for_page(page_index)
	var InteractiveSentence = load("res://Lexical/Sentence/InteractiveSentence.tscn")
	for interactive_sentence in interactive_sentences:
		interactive_sentence.queue_free()
	interactive_sentences = []
	active_page = "left"
	var x = X_TOP_OF_PAGE
	var y = CENTER_LEFT_PAGE_X
	var index_in_page = 0
	for sentence in all_sentences:
		var interactive_sentence = InteractiveSentence.instance()
		interactive_sentence.init_interactive_sentence(sentence, null)
		interactive_sentences.append(interactive_sentence)
		$Control.add_child(interactive_sentence)
		interactive_sentence.position = Vector2(y, x)
		interactive_sentence.scale = Vector2(0.5, 0.5)
		x += 30
		index_in_page += 1
		if index_in_page >= NUMBER_OF_SENTENCES_PER_PAGE:
			if active_page == "left":
				x = X_TOP_OF_PAGE
				y = CENTER_RIGHT_PAGE_X
				index_in_page = 0
				active_page = "right"
			else:
				break

func next_page():
	current_page_index += 1
	init(current_page_index)
	
func previous_page():
	if current_page_index > 0:
		current_page_index -= 1
		init(current_page_index)

func _on_NextPage_pressed():
	next_page()

func _on_PreviousPage_pressed():
	previous_page()
