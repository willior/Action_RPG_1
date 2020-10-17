extends Node2D

export(int) var minTimeBetweenLightning = 10
export(int) var maxTimeBetweenLightning = 20
var lightningTimer = 0
var lightningPause = false

func _ready():
	randomize()
	lightningTimer = rand_range(minTimeBetweenLightning, maxTimeBetweenLightning)
