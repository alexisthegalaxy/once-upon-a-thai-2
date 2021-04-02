extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const teal = Color(0.137254902, 1, 0.952941176, 1)
const white = Color(1, 1, 1, 1)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func mouse_in(button):
	button.modulate = teal
func mouse_out(button):
	button.modulate = white
func on_press(province_name):
	print(province_name)
	SoundPlayer.play_thai(Game.provinces[province_name].th)
	for word_id in Game.provinces[province_name].words:
		print(Game.words[str(word_id)].th)
	

func _on_khonkaen_mouse_entered():
	mouse_in($khonkaen)
func _on_khonkaen_mouse_exited():
	mouse_out($khonkaen)
#	$khonkaen.modulate = Color(1, 1, 1, 1)
func _on_khonkaen_pressed():
	on_press('khonkaen')

func _on_chaiyaphum_mouse_entered():
	mouse_in($chaiyaphum)
func _on_chaiyaphum_mouse_exited():
	mouse_out($chaiyaphum)
func _on_chaiyaphum_pressed():
	on_press('chaiyaphum')


func _on_mahasarakham_pressed():
	on_press('mahasarakham')
func _on_mahasarakham_mouse_entered():
	mouse_in($mahasarakham)
func _on_mahasarakham_mouse_exited():
	mouse_out($mahasarakham)

func _on_kalasin_pressed():
	on_press('kalasin')
func _on_kalasin_mouse_entered():
	mouse_in($kalasin)
func _on_kalasin_mouse_exited():
	mouse_out($kalasin)

func _on_udonthani_pressed():
	on_press('udonthani')
func _on_udonthani_mouse_entered():
	mouse_in($udonthani)
func _on_udonthani_mouse_exited():
	mouse_out($udonthani)
