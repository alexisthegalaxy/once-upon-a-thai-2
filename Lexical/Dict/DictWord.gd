extends StaticBody2D

func set_thai(thai):
	$thai.text = thai

func set_known(is_known):
	if is_known:
		$Sprite.modulate = Color(0, 1, 1)
