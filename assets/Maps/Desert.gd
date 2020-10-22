extends Node2D

var wind_direction = "left" setget set_wind_direction
var wind_strength = 0 setget set_wind_strength

func _ready():
	wind_strength = -128
	self.wind_strength = wind_strength
	prints("wind_direction = " + wind_direction)
		
func set_wind_direction(value):
	wind_direction = value
	if wind_direction == "left":
		$ParallaxOverlay/ParallaxLayer2/Particles2D.process_material.direction.x = -1
	elif wind_direction == "right":
		$ParallaxOverlay/ParallaxLayer2/Particles2D.process_material.direction.x = 1
	
func set_wind_strength(value):
	wind_strength = value
	print("!!!")
	if wind_strength < 0:
		wind_direction = "left"
		self.wind_direction = wind_direction
	elif wind_strength >= 0:
		wind_direction = "right"
		self.wind_direction = wind_direction
