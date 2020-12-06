extends StaticBody2D


export(Array, int) var word_ids = []
var words = []
var overworld_special_effect_letters_ring_1 = []
var overworld_special_effect_letters_ring_2 = []
var overworld_special_effect_letters_ring_3 = []
var ShardRotatingLetter = load("res://World/ShardRotatingLetter.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for word_id in word_ids:
		words.append(Game.words[str(word_id)])
	var i = 0
	for word in words:
		for letter_id in word.letters:
			var letter = Game.letters[str(letter_id)].th
			if i % 3 == 0:
				var shard_rotating_letter = ShardRotatingLetter.instance()
				shard_rotating_letter.init_shard_rotating_letter(letter, i, 1)
				self.add_child(shard_rotating_letter)
			if i % 3 == 1:
				var shard_rotating_letter = ShardRotatingLetter.instance()
				shard_rotating_letter.init_shard_rotating_letter(letter, i, 2)
				self.add_child(shard_rotating_letter)
			if i % 3 == 2:
				var shard_rotating_letter = ShardRotatingLetter.instance()
				shard_rotating_letter.init_shard_rotating_letter(letter, i, 3)
				self.add_child(shard_rotating_letter)
			i += 1

func interact():
	var dialog = [tr("_this_emits_an_evil_aura")]
	get_tree().set_input_as_handled()
	Game.player.can_interact = false
	Game.is_frozen = true
	Game.lose_focus(null)
	Game.player.stop_walking()
	Game.current_dialog = load("res://Dialog/Dialog.tscn").instance()
	Game.current_dialog.init_dialog(dialog, self, "post_dialog", false, null)
	Game.current_scene.add_child(Game.current_dialog)

func post_dialog():
	Game.is_frozen = true
	var test_start_animation = load("res://Test/TestStartAnimation.tscn").instance()
	test_start_animation.init_start_animation("", "Shard")
	self.add_child(test_start_animation)
	test_start_animation.connect("test_can_start", self, "start_purifying_after_animation")

func start_purifying_after_animation():
	Game.start_test("res://Test/Purifying/TestPurifying.tscn", word_ids, self)

func _on_Area2D_body_entered(body):
	if not body == Game.player:
		return
	Game.gains_focus(self)

func _on_Area2D_body_exited(body):
	if not body == Game.player:
		return
	Game.lose_focus(self)

