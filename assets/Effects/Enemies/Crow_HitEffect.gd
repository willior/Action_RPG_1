extends AnimatedSprite

var rng = randi()%4+1

func _ready():
	randomize()
	play(str(rng))

func _on_CrowHitEffect_animation_finished():
	pass
