extends Node2D

var speed = 10
var direction

func _ready():
	direction = Vector2(rand_range(250, -250), rand_range(250, -250)).normalized()
	$Label.text = Game.words[str(randi() % len(Game.words))].th

func init_ceremony_leaving_word_orb(_speed):
	speed = _speed

func _process(delta):
	position += direction * speed * delta
	speed += delta / 3
	modulate.a -= delta / 10
	if modulate.a <= 0:
		queue_free()

func _on_Timer_timeout():
	queue_free()
