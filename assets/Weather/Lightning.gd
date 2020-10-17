extends Node2D

export(int) var minTimeBetweenLightning = 10
export(int) var maxTimeBetweenLightning = 20
var lightningTimer = 0
var lightningPause = false

func _ready():
	randomize()
	lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
	print(lightningTimer)

#func _process(delta):
#	if !lightningPause:
#		lightningTimer -= delta
#		if lightningTimer <= 0:
#			print('playing lightning')
#			$AnimationPlayer.play("Lightning1")
#			yield(get_tree().create_timer(1), "timeout")
#			print('timeout: playing thunder')
#			$AudioStreamPlayer.play()
#			lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
#			print(lightningTimer)
			
func lightning_strike():
	$AnimationPlayer.play("Lightning1")
	print('playing lightning')
	yield(get_tree().create_timer(2), "timeout")
	print('timeout: playing thunder')
	$AudioStreamPlayer.play()

func _on_Timer_timeout():
	lightning_strike()
	lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
	print(lightningTimer)
	$Timer.start(lightningTimer)
