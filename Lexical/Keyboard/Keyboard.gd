extends Node2D

# A keyboard contains all the keys, but also
#    a string that tracks what is being written
var s = ""
var shift
signal text_change
signal enter_pressed
var restrict_to_collected_letters
const HIGHLIGHT_COLOR = Color(0, 1, 1, 1)
var all_keys = []

func init_keyboard(_restrict_to_collected_letters):
	restrict_to_collected_letters = _restrict_to_collected_letters
	# First row
	$"ๅ".init_keyboard_key("ๅ", "+", self)
	$"2".init_keyboard_key("/", "๑", self)
	$"3".init_keyboard_key("_", "๒", self)
	$"ภ".init_keyboard_key("ภ", "๓", self)
	$"ถ".init_keyboard_key("ถ", "๔", self)
	$"-ุ".init_keyboard_key("-ุ", "-ู", self)
	$"-ึ".init_keyboard_key("-ึ", "฿", self)
	$"ค".init_keyboard_key("ค", "๕", self)
	$"ต".init_keyboard_key("ต", "๖", self)
	$"จ".init_keyboard_key("จ", "๗", self)
	$"ข".init_keyboard_key("ข", "๘", self)
	$"ช".init_keyboard_key("ช", "๙", self)
	# Second row
	$"ๆ".init_keyboard_key("ๆ", "๐", self)
	$"ไ".init_keyboard_key("ไ", "\"", self)
	$"-ำ".init_keyboard_key("-ำ", "ฎ", self)
	$"พ".init_keyboard_key("พ", "ฑ", self)
	$"ะ".init_keyboard_key("ะ", "ธ", self)
	$"-ั".init_keyboard_key("-ั", "-ํ", self)
	$"-ี".init_keyboard_key("-ี", "-๊", self)
	$"ร".init_keyboard_key("ร", "ณ", self)
	$"น".init_keyboard_key("น", "ฯ", self)
	$"ย".init_keyboard_key("ย", "ญ", self)
	$"บ".init_keyboard_key("บ", "ฐ", self)
	$"ล".init_keyboard_key("ล", ",", self)
	# Third row
	$"ฟ".init_keyboard_key("ฟ", "ฤ", self)
	$"ห".init_keyboard_key("ห", "ฆ", self)
	$"ก".init_keyboard_key("ก", "ฏ", self)
	$"ด".init_keyboard_key("ด", "โ", self)
	$"เ".init_keyboard_key("เ", "ฌ", self)
	$"-้".init_keyboard_key("-้", "-็", self)
	$"-่".init_keyboard_key("-่", "-๋", self)
	$"า".init_keyboard_key("า", "ษ", self)
	$"ส".init_keyboard_key("ส", "ศ", self)
	$"ว".init_keyboard_key("ว", "ซ", self)
	$"ง".init_keyboard_key("ง", ".", self)
	$"ฃ".init_keyboard_key("ฃ", "ฅ", self)
	# Fourth row
	$"ผ".init_keyboard_key("ผ", "(", self)
	$"ป".init_keyboard_key("ป", ")", self)
	$"แ".init_keyboard_key("แ", "ฉ", self)
	$"อ".init_keyboard_key("อ", "ฮ", self)
	$"-ิ".init_keyboard_key("-ิ", "-ฺ", self)
	$"-ื".init_keyboard_key("-ื", "-์", self)
	$"ท".init_keyboard_key("ท", "?", self)
	$"ม".init_keyboard_key("ม", "ฒ", self)
	$"ใ".init_keyboard_key("ใ", "ฬ", self)
	$"ฝ".init_keyboard_key("ฝ", "ฦ", self)
	# Special keys
	$Lshift.init_keyboard_key("shift", "none", self)
	$Rshift.init_keyboard_key("shift", "none", self)
	$BackSpace.init_keyboard_key("back", "none", self)
	
	all_keys = [$"ๅ", $"2", $"3", $"ภ", $"ถ", $"-ุ", $"-ึ", $"ค", $"ต", $"จ", $"ข", $"ช", $"ๆ", $"ไ", $"พ", $"ะ", $"-ั", $"-ี", $"ร", $"น", $"ย", $"บ", $"ล", $"ฟ", $"ห", $"ก", $"ด", $"เ", $"-้", $"-่", $"า", $"ส", $"ว", $"ง", $"ฃ", $"ผ", $"ป", $"แ", $"อ", $"-ิ", $"-ื", $"ท", $"ม", $"ใ", $"ฝ", $"-ำ", $Lshift, $Rshift, $BackSpace]

func _input(_event):
	# First row
	if _event.is_action_pressed("kb_1"):
		$"ๅ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_2"):
		$"2"._on_Button_pressed()
	elif _event.is_action_pressed("kb_3"):
		$"3"._on_Button_pressed()
	elif _event.is_action_pressed("kb_4"):
		$"ภ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_5"):
		$"ถ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_6"):
		$"-ุ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_7"):
		$"-ึ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_8"):
		$"ค"._on_Button_pressed()
	elif _event.is_action_pressed("kb_9"):
		$"ต"._on_Button_pressed()
	elif _event.is_action_pressed("kb_0"):
		$"จ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_-"):
		$"ข"._on_Button_pressed()
	elif _event.is_action_pressed("kb_equal"):
		$"ช"._on_Button_pressed()

	# Second row
	elif _event.is_action_pressed("kb_q"):
		$"ๆ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_w"):
		$"ไ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_e"):
		$"-ำ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_r"):
		$"พ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_t"):
		$"ะ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_y"):
		$"-ั"._on_Button_pressed()
	elif _event.is_action_pressed("kb_u"):
		$"-ี"._on_Button_pressed()
	elif _event.is_action_pressed("kb_i"):
		$"ร"._on_Button_pressed()
	elif _event.is_action_pressed("kb_o"):
		$"น"._on_Button_pressed()
	elif _event.is_action_pressed("kb_p"):
		$"ย"._on_Button_pressed()
	elif _event.is_action_pressed("kb_["):
		$"บ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_]"):
		$"ล"._on_Button_pressed()

	# Third row
	elif _event.is_action_pressed("kb_a"):
		$"ฟ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_s"):
		$"ห"._on_Button_pressed()
	elif _event.is_action_pressed("kb_d"):
		$"ก"._on_Button_pressed()
	elif _event.is_action_pressed("kb_f"):
		$"ด"._on_Button_pressed()
	elif _event.is_action_pressed("kb_g"):
		$"เ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_h"):
		$"-้"._on_Button_pressed()
	elif _event.is_action_pressed("kb_j"):
		$"-่"._on_Button_pressed()
	elif _event.is_action_pressed("kb_k"):
		$"า"._on_Button_pressed()
	elif _event.is_action_pressed("kb_l"):
		$"ส"._on_Button_pressed()
	elif _event.is_action_pressed("kb_semicolon"):
		$"ว"._on_Button_pressed()
	elif _event.is_action_pressed("kb_apostrophe"):
		$"ง"._on_Button_pressed()
	elif _event.is_action_pressed("kb_backslash"):
		$"ฃ"._on_Button_pressed()

	# Fourth row
	elif _event.is_action_pressed("kb_z"):
		$"ผ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_x"):
		$"ป"._on_Button_pressed()
	elif _event.is_action_pressed("kb_c"):
		$"แ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_v"):
		$"อ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_b"):
		$"-ิ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_n"):
		$"-ื"._on_Button_pressed()
	elif _event.is_action_pressed("kb_m"):
		$"ท"._on_Button_pressed()
	elif _event.is_action_pressed("kb_,"):
		$"ม"._on_Button_pressed()
	elif _event.is_action_pressed("kb_."):
		$"ใ"._on_Button_pressed()
	elif _event.is_action_pressed("kb_slash"):
		$"ฝ"._on_Button_pressed()
	# Special keys
	elif _event.is_action_pressed("kb_backspace"):
		$"BackSpace"._on_Button_pressed()
	elif _event.is_action_pressed("kb_shift"):
		shift_down()
	elif _event.is_action_released("kb_shift"):
		shift_up()
	elif _event.is_action_released("kb_enter"):
		emit_signal("enter_pressed")

func shift_down():
	shift = true
	update_all_keys_upon_shift()

func shift_up():
	shift = false
	update_all_keys_upon_shift()

func update_all_keys_upon_shift():
	$"ๅ".update_upon_shift()
	$"2".update_upon_shift()
	$"3".update_upon_shift()
	$"ภ".update_upon_shift()
	$"ถ".update_upon_shift()
	$"-ุ".update_upon_shift()
	$"-ึ".update_upon_shift()
	$"ค".update_upon_shift()
	$"ต".update_upon_shift()
	$"จ".update_upon_shift()
	$"ข".update_upon_shift()
	$"ช".update_upon_shift()
	# Second row
	$"ๆ".update_upon_shift()
	$"ไ".update_upon_shift()
	$"-ำ".update_upon_shift()
	$"พ".update_upon_shift()
	$"ะ".update_upon_shift()
	$"-ั".update_upon_shift()
	$"-ี".update_upon_shift()
	$"ร".update_upon_shift()
	$"น".update_upon_shift()
	$"ย".update_upon_shift()
	$"บ".update_upon_shift()
	$"ล".update_upon_shift()
	# Third row
	$"ฟ".update_upon_shift()
	$"ห".update_upon_shift()
	$"ก".update_upon_shift()
	$"ด".update_upon_shift()
	$"เ".update_upon_shift()
	$"-้".update_upon_shift()
	$"-่".update_upon_shift()
	$"า".update_upon_shift()
	$"ส".update_upon_shift()
	$"ว".update_upon_shift()
	$"ง".update_upon_shift()
	$"ฃ".update_upon_shift()
	# Fourth row
	$"ผ".update_upon_shift()
	$"ป".update_upon_shift()
	$"แ".update_upon_shift()
	$"อ".update_upon_shift()
	$"-ิ".update_upon_shift()
	$"-ื".update_upon_shift()
	$"ท".update_upon_shift()
	$"ม".update_upon_shift()
	$"ใ".update_upon_shift()
	$"ฝ".update_upon_shift()

func on_backspace():
	print('s s.length() ', s.length())
	if s.length() == 0:
		return
	var last_char = s[s.length() - 1]
	print('last_char', last_char)
	s.erase(s.length() - 1, 1)
	var keys = get_tree().get_nodes_in_group("keyboard_keys")
	for key in keys:
		key.update_after_char_is_backspaced(last_char)

func receive_key_value(key_value):
	if key_value == "shift":
		return
	if key_value == "back":
		on_backspace()
	else:
		s += key_value.replace('-', '')
	emit_signal("text_change", s)

func reset_key_highlights():
	for key in all_keys:
		key.modulate = Color(1, 1, 1, 1)

func highlight_shift_keys():
	$Lshift.modulate = HIGHLIGHT_COLOR
	$Rshift.modulate = HIGHLIGHT_COLOR

func highlight_letter(letter):
	reset_key_highlights()
	if letter == "ๅ":
		$"ๅ".modulate = HIGHLIGHT_COLOR
	elif letter == "+":
		$"ๅ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "/":
		$"2".modulate = HIGHLIGHT_COLOR
	elif letter == "๑":
		$"2".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "_":
		$"3".modulate = HIGHLIGHT_COLOR
	elif letter == "๒":
		$"3".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ภ":
		$"ภ".modulate = HIGHLIGHT_COLOR
	elif letter == "๓":
		$"ภ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ถ":
		$"ถ".modulate = HIGHLIGHT_COLOR
	elif letter == "๔":
		$"ถ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ุ":
		$"-ุ".modulate = HIGHLIGHT_COLOR
	elif letter == "ู":
		$"-ุ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ึ":
		$"-ึ".modulate = HIGHLIGHT_COLOR
	elif letter == "฿":
		$"-ึ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ค":
		$"ค".modulate = HIGHLIGHT_COLOR
	elif letter == "๕":
		$"ค".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ต":
		$"ต".modulate = HIGHLIGHT_COLOR
	elif letter == "๖":
		$"ต".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "จ":
		$"จ".modulate = HIGHLIGHT_COLOR
	elif letter == "๗":
		$"จ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ข":
		$"ข".modulate = HIGHLIGHT_COLOR
	elif letter == "๘":
		$"ข".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ช":
		$"ช".modulate = HIGHLIGHT_COLOR
	elif letter == "๙":
		$"ช".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
	
	# Second row
	elif letter == "ๆ":
		$"ๆ".modulate = HIGHLIGHT_COLOR
	elif letter == "๐":
		$"ๆ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ไ":
		$"ไ".modulate = HIGHLIGHT_COLOR
	elif letter == "\"":
		$"ไ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ำ":
		$"-ำ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฎ":
		$"-ำ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "พ":
		$"พ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฑ":
		$"พ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ะ":
		$"ะ".modulate = HIGHLIGHT_COLOR
	elif letter == "ธ":
		$"ะ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ะ":
		$"ะ".modulate = HIGHLIGHT_COLOR
	elif letter == "ธ":
		$"ะ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ั":
		$"-ั".modulate = HIGHLIGHT_COLOR
	elif letter == "ํ":
		$"-ั".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ี":
		$"-ี".modulate = HIGHLIGHT_COLOR
	elif letter == "๊":
		$"-ี".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ร":
		$"ร".modulate = HIGHLIGHT_COLOR
	elif letter == "ณ":
		$"ร".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "น":
		$"น".modulate = HIGHLIGHT_COLOR
	elif letter == "ฯ":
		$"น".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ย":
		$"ย".modulate = HIGHLIGHT_COLOR
	elif letter == "ญ":
		$"ย".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "บ":
		$"บ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฐ":
		$"บ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ล":
		$"ล".modulate = HIGHLIGHT_COLOR
	elif letter == ",":
		$"ล".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	# Third row
	elif letter == "ฟ":
		$"ฟ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฤ":
		$"ฟ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ห":
		$"ห".modulate = HIGHLIGHT_COLOR
	elif letter == "ฆ":
		$"ห".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ก":
		$"ก".modulate = HIGHLIGHT_COLOR
	elif letter == "ฏ":
		$"ก".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ด":
		$"ด".modulate = HIGHLIGHT_COLOR
	elif letter == "โ":
		$"ด".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "เ":
		$"เ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฌ":
		$"เ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "้":
		$"-้".modulate = HIGHLIGHT_COLOR
	elif letter == "็":
		$"-้".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "่":
		$"-่".modulate = HIGHLIGHT_COLOR
	elif letter == "๋":
		$"-่".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "า":
		$"า".modulate = HIGHLIGHT_COLOR
	elif letter == "ษ":
		$"า".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ส":
		$"ส".modulate = HIGHLIGHT_COLOR
	elif letter == "ศ":
		$"ส".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ว":
		$"ว".modulate = HIGHLIGHT_COLOR
	elif letter == "ซ":
		$"ว".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ง":
		$"ง".modulate = HIGHLIGHT_COLOR
	elif letter == ".":
		$"ง".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	elif letter == "ฃ":
		$"ฃ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฅ":
		$"ฃ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()

	# Fourth row
	elif letter == "ผ":
		$"ผ".modulate = HIGHLIGHT_COLOR
	elif letter == "(":
		$"ผ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ป":
		$"ป".modulate = HIGHLIGHT_COLOR
	elif letter == ")":
		$"ป".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "แ":
		$"แ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฉ":
		$"แ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "อ":
		$"อ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฮ":
		$"อ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ิ":
		$"-ิ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฺ":
		$"-ิ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ื":
		$"-ื".modulate = HIGHLIGHT_COLOR
	elif letter == "์":
		$"-ื".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ท":
		$"ท".modulate = HIGHLIGHT_COLOR
	elif letter == "?":
		$"ท".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ม":
		$"ม".modulate = HIGHLIGHT_COLOR
	elif letter == "ฒ":
		$"ม".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ใ":
		$"ใ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฬ":
		$"ใ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
		
	elif letter == "ฝ":
		$"ฝ".modulate = HIGHLIGHT_COLOR
	elif letter == "ฦ":
		$"ฝ".modulate = HIGHLIGHT_COLOR
		highlight_shift_keys()
	
	elif letter == "backspace":
		$BackSpace.modulate = HIGHLIGHT_COLOR
	elif letter == "enter":
		$BackSpace.modulate = HIGHLIGHT_COLOR
