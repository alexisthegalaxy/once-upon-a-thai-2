extends CanvasLayer


const NUMBER_OF_UNITS_PER_LINE = 5
var over_source

func s_x(x):
	return x * 50 + 5

func s_y(y):
	return y * 32 + 16

func init_select_follower_to_implant_screen(over_source):
	if over_source:
		$Label.text = tr("_select_spell_to_implant")
	else:
		$Label.text = tr("_select_spell_to_cast")
	var Unit = load("res://Lexical/Source/SelectFollowerToImplantUnit.tscn")
	var x = 0
	var y = 0
	var varying_y = 3
	for follower in Game.following_spells:
		var unit = Unit.instance()
		$Control.add_child(unit)
#		displayed_words.append(dict_word)
		unit.init_select_follower_to_implant_unit(follower.id, over_source)
		unit.position = Vector2(s_x(x), s_y(y) + varying_y)
		varying_y = -varying_y
		x += 1
		if x > NUMBER_OF_UNITS_PER_LINE:
			y += 1
			x = 0

#func init_select_follower_to_implant():
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
