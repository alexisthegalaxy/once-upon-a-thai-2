extends StaticBody2D

export var is_pulsating = false
export var is_corrupted = false
export var type = "SacredRock"
var time = 0
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var main_sprite = "res://World/assets/" + type + ".png"
	var pulsating_sprite = "res://World/assets/Pulsing" + type + ".png"
	var light_sprite = "res://World/assets/" + type + "Light.png"
#	print(main_sprite)
#	print(pulsating_sprite)
#	print(light_sprite)
	$Sprite.texture = load(main_sprite)
	$PulsatingSprite.texture = load(pulsating_sprite)
	$Light.texture = load(light_sprite)
	
	
	rng.randomize()
	if not is_pulsating:
		$PulsatingSprite.hide()
		$Light.hide()
	if is_corrupted:
		$Sprite.hide()
		$CorruptedSprite.show()
		var _e = $Timer.connect("timeout", self, "timeout")
	else:
		$CorruptedSprite.hide()

func timeout():
	var new_orb = load("res://World/CorruptionOrb.tscn").instance()
	new_orb.position = Vector2(0, -25.595)
#	new_orb.position = position
	var scale = rng.randf_range(0.2, 0.5)
	new_orb.max_scale = Vector2(scale, scale)
	new_orb.velocity = Vector2(rng.randf_range(-2, 2), -8)
#	get_tree().current_scene.add_child(new_orb)
	self.add_child(new_orb)

func _process(delta):
	if is_pulsating:
		time += delta
		var ondulation = cos(time)
		var alpha = 0.7 - 0.3 * ondulation
#		$Light.modulate = Color(1, 1, 1, alpha)
		$Light.energy = alpha
		$PulsatingSprite.modulate = Color(1, 1, 1, alpha)
