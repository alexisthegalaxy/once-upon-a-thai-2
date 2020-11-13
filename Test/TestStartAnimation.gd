extends CanvasLayer


# The screen shakes,
# an anime style white band appears
# The word appears from the left, then stops at the middle, then becomes bigger
# The test appears in the background
# This TestStartAnimation fades out


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().get_current_scene().rotate(0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
