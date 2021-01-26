extends Node2D

export(int) var minTimeBetweenLightning = 16
export(int) var maxTimeBetweenLightning = 32
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
	$AnimationPlayer.play("Lightning1")
	
func set_light_energy(value):
	$Light2D.energy = value
	$Light2D2.energy = value
	$Light2D3.energy = value
