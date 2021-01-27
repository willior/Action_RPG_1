extends AnimatedSprite

var rng = randi()%4+1

func _ready():
	randomize()
	play(str(rng))
	rng = randi()%2+1
	if rng == 2:
		flip_h = true
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
