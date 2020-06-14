extends CanvasLayer

func _ready():
	pass # Replace with function body.

func hide():
	$bg.hide()
	$right_arrow.hide()
	$left_arrow.hide()

func show():
	$bg.show()
	$right_arrow.show()
	$left_arrow.show()
