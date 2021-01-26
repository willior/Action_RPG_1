extends AnimatedSprite

func _ready():
# warning-ignore:return_value_discarded
	connect("animation_finished", self, "_on_animation_finished")
	$AudioStreamPlayer.play()
	play("Animate")

func _on_animation_finished():
	$AudioStreamPlayer.queue_free()
