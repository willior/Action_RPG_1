extends Area2D
var rng = randi()%2+1
func _ready():
# warning-ignore:return_value_discarded
	$BloodAnimation.connect("animation_finished", self, "_on_animation_finished")
	$BloodAnimation.play("1")
	if rng == 2:
		$BloodAnimation.flip_h = true

func _process(_delta):
	global_position = global_position.round()
	set_process(false)

func _on_animation_finished():
	$AudioStreamPlayer.queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
