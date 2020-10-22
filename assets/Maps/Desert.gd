extends Node2D

var wind_speed
var wind_direction = "left" setget set_wind_direction
var wind_strength

func _ready():
	prints("wind_direction = " + wind_direction)
	if wind_direction == "left":
		$ParallaxOverlay/ParallaxLayer2/Particles2D.process_material.direction.x = -1
	elif wind_direction == "right":
		$ParallaxOverlay/ParallaxLayer2/Particles2D.process_material.direction.x = 1
		
func set_wind_direction(value):
	wind_direction = value
	
func set_wind_strength(value):
	wind_strength = value
