extends CanvasLayer

# var b = "text"
const teal = Color(0.137254902, 1, 0.952941176, 1)
const white = Color(1, 1, 1, 1)
var map_info_bubble
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func init_map():
	pass

func mouse_in(button):
	button.modulate = teal
	if map_info_bubble:
		map_info_bubble.queue_free()
	map_info_bubble = load("res://Map/MapInfoBubble.tscn").instance()
	self.add_child(map_info_bubble)
	map_info_bubble._init_map_info_bubble(button.name)
func mouse_out(button):
	button.modulate = white
	if map_info_bubble:
		map_info_bubble.queue_free()
func on_press(province_name):
	print(province_name)
	SoundPlayer.play_thai(Game.provinces[province_name].th)
	for word_id in Game.provinces[province_name].words:
		print(Game.words[str(word_id)].th)

func _on_khonkaen_mouse_entered():
	mouse_in($Node2D/khonkaen)
func _on_khonkaen_mouse_exited():
	mouse_out($Node2D/khonkaen)
#	$khonkaen.modulate = Color(1, 1, 1, 1)
func _on_khonkaen_pressed():
	on_press('khonkaen')

func _on_chaiyaphum_mouse_entered():
	mouse_in($Node2D/chaiyaphum)
func _on_chaiyaphum_mouse_exited():
	mouse_out($Node2D/chaiyaphum)
func _on_chaiyaphum_pressed():
	on_press('chaiyaphum')


func _on_mahasarakham_pressed():
	on_press('mahasarakham')
func _on_mahasarakham_mouse_entered():
	mouse_in($Node2D/mahasarakham)
func _on_mahasarakham_mouse_exited():
	mouse_out($Node2D/mahasarakham)

func _on_kalasin_pressed():
	on_press('kalasin')
func _on_kalasin_mouse_entered():
	mouse_in($Node2D/kalasin)
func _on_kalasin_mouse_exited():
	mouse_out($Node2D/kalasin)

func _on_udonthani_pressed():
	on_press('udonthani')
func _on_udonthani_mouse_entered():
	mouse_in($Node2D/udonthani)
func _on_udonthani_mouse_exited():
	mouse_out($Node2D/udonthani)

func _on_roiet_pressed():
	on_press('roiet')
func _on_roiet_mouse_entered():
	mouse_in($Node2D/roiet)
func _on_roiet_mouse_exited():
	mouse_out($Node2D/roiet)

func _on_lopburi_pressed():
	on_press('lopburi')
func _on_lopburi_mouse_entered():
	mouse_in($Node2D/lopburi)
func _on_lopburi_mouse_exited():
	mouse_out($Node2D/lopburi)

func _on_phetchabun_pressed():
	on_press('phetchabun')
func _on_phetchabun_mouse_entered():
	mouse_in($Node2D/phetchabun)
func _on_phetchabun_mouse_exited():
	mouse_out($Node2D/phetchabun)
	
func _on_nongbualamphu_pressed():
	on_press('nongbualamphu')
func _on_nongbualamphu_mouse_entered():
	mouse_in($Node2D/nongbualamphu)
func _on_nongbualamphu_mouse_exited():
	mouse_out($Node2D/nongbualamphu)


func _on_nakhonratchasima_pressed():
	on_press('nakhonratchasima')
func _on_nakhonratchasima_mouse_entered():
	mouse_in($Node2D/nakhonratchasima)
func _on_nakhonratchasima_mouse_exited():
	mouse_out($Node2D/nakhonratchasima)
