extends AnimatedSprite
var rng = randi()%2+1
func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	$AudioStreamPlayer.play()
	play("Animate")
	$AnimatedSprite2.play("1")
	if rng == 2:
		$AnimatedSprite2.flip_h = true

func _on_animation_finished():
	$AudioStreamPlayer.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()