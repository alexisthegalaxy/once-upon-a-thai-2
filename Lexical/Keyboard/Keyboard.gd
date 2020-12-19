extends Node2D

# A keyboard contains all the keys, but also
#    a string that tracks what is being written
var s = ""
var shift

func _ready():
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
	$"จ".init_keyboard_key("ต", "๗", self)
	$"ข".init_keyboard_key("จ", "๘", self)
	$"ช".init_keyboard_key("ข", "๙", self)
	# Second row
	$"ๆ".init_keyboard_key("ๆ", "๐", self)
	$"ไ".init_keyboard_key("ไ", "\"", self)
	$"-ำ".init_keyboard_key("_ำ", "ฎ", self)
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

func receive_key_value(key_value):
	if key_value == "shift":
		return
	if key_value == "back":
		s.erase(s.length() - 1, 1)
		return
	s += key_value.replace('-', '')
