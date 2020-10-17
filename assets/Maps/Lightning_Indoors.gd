extends Node2D

export(int) var minTimeBetweenLightning = 12
export(int) var maxTimeBetweenLightning = 24
var lightningTimer = 0
var lightningPause = false
var lightningEnergy = 0

func _ready():
	randomize()

func _on_Timer_timeout():
	lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
	lightning_strike()

func lightning_strike():
	$Timer.start(lightningTimer)
	prints(str(lightningTimer) + " second til next lightning")
	$AnimationPlayer.play("Lightning1")
