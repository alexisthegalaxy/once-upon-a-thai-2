extends CanvasLayer
signal test_can_start
var alpha = 0
var time = 0
enum {
	# The screen becomes white
	# The screen shakes
	# The music starts
	PHASE_1,
	
	# The text pops from the bottom
	# The Spell name pops from the top
	PHASE_2,
	
	# The test appears
	# This starts to disappear
	PHASE_3,
}
var phase = PHASE_1
var random_sign = pow(-1, randi() % 2)

# Called when the node enters the scene tree for the first time.
func _ready():
	$White.modulate = Color(1, 1, 1, alpha)
	$TextNode.position.y += 200
	$SpellNode.position.y -= 200

func init(enemy_name, enemy_type):
	$TextNode/Text.text = "A wild " + enemy_type + " attacks!"
	$SpellNode/Spell.text = enemy_name

func _process(delta):
	time += delta
	if phase == PHASE_1:
		alpha = min(1, alpha + delta / 2)
		$White.modulate = Color(1, 1, 1, alpha)
		Game.current_scene.rotation = random_sign * pow(sin(2 * time * time), 2) / 5
	elif phase == PHASE_2:
		alpha = min(1, alpha + delta)
		$White.modulate = Color(1, 1, 1, alpha)
		Game.current_scene.rotation = random_sign * pow(sin(2 * time * time), 2) / 5
		
		$TextNode.position.y -= delta * 200
		$SpellNode.position.y += delta * 200
	elif phase == PHASE_3:
		alpha -= delta
		$White.modulate = Color(1, 1, 1, alpha)
		$TextNode.modulate = Color(1, 1, 1, alpha)
		$SpellNode.modulate = Color(1, 1, 1, alpha)
		if alpha <= 0:
			queue_free()

func _on_TimerUntilSpellAppears_timeout():
	phase = PHASE_2

func _on_TimerUntilTextDisappears_timeout():
	Game.current_scene.rotation = 0
	time = 0
	alpha = 1
	emit_signal("test_can_start")
	phase = PHASE_3
