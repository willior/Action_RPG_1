extends Node2D

export(int) var minTimeBetweenLightning = 10
export(int) var maxTimeBetweenLightning = 20
var lightningTimer = 0
var lightningPause = false

func _ready():
	randomize()
	lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)

func _process(delta):
	if !lightningPause:
		lightningTimer -= delta
		if lightningTimer <= 0:
			print('playing lightning')
			$AnimationPlayer.play("Lightning1")
			yield(get_tree().create_timer(2), "timeout")
			print('timeout: animation stopping')
			$AnimationPlayer.stop(true)
			yield(get_tree().create_timer(2), "timeout")
			print('timeout: playing thunder')
			$AudioStreamPlayer.play()
			lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
