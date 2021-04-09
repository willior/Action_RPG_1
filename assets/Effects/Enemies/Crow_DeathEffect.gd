extends Area2D
var rng = randi()%2+1
func _ready():
# warning-ignore:return_value_discarded
	$Crow_DeathAnimation.connect("animation_finished", self, "_on_animation_finished")
	$Crow_DeathAnimation/AudioStreamPlayer.play()
	$Crow_DeathAnimation.play("Animate")
	$Crow_DeathAnimation/AnimatedSprite2.play("1")
	if rng == 2:
		$Crow_DeathAnimation/AnimatedSprite2.flip_h = true

func _process(_delta):
	global_position = global_position.round()
	set_process(false)

func _on_animation_finished():
	$Crow_DeathAnimation/AudioStreamPlayer.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
