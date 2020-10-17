extends Node2D

export(int) var minTimeBetweenLightning = 12
export(int) var maxTimeBetweenLightning = 24
var lightningTimer = 0
var lightningPause = false

func _ready():
	randomize()

func lightning_strike():
	$Timer.start(lightningTimer)
	prints(str(lightningTimer) + " second til next lightning")
	$AnimationPlayer.play("Lightning1")

func _on_Timer_timeout():
	lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
	lightning_strike()
