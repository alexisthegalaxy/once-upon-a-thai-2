extends CanvasLayer

export var dialog = []
var page = 0
var player

func _ready():
	reset_line()

func reset_line():
	$Control/RichTextLabel.set_bbcode(dialog[page])
	$Control/RichTextLabel.set_visible_characters(0)

func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		if $Control/RichTextLabel.get_visible_characters() > $Control/RichTextLabel.get_total_character_count():
			page += 1
			if page >= dialog.size():
				queue_free()
				player.end_dialog()
			else:
				reset_line()

func _on_Timer_timeout():
	$Control/RichTextLabel.set_visible_characters($Control/RichTextLabel.get_visible_characters() + 1)
