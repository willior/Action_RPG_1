extends Area2D

var speed = 200
var target_position : Vector2

func _ready():
	randomize()
	var rng = randi()%4+1
	$CrowHitAnimation.play(str(rng))
	rng = randi()%2+1
	if rng == 2:
		$CrowHitAnimation.flip_h = true

func _process(delta):
	global_position = global_position.move_toward(target_position, delta*speed)
	if global_position == target_position:
		global_position = global_position.move_toward(Vector2.ZERO, delta*speed)
		set_process(false)
	global_position = global_position.round()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
