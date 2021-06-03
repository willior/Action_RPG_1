extends Node2D
var player_spawn_pos = Vector2(480,264)
var wind_direction = "left" setget set_wind_direction
var wind_strength = 0 setget set_wind_strength
var particle_amount = 100 setget set_particle_amount
var current_wind_strength
var current_particles_amount
var end_value_particles

onready var particles = $ParallaxOverlay/ParallaxLayer2/Particles2D
onready var overlay = $ParallaxOverlay/ParallaxLayer/Sprite
onready var tween = $Tween

func _ready():
	randomize()
	self.wind_strength = wind_strength
	self.particle_amount = particle_amount
	
func set_wind_direction(value):
	wind_direction = value
	prints("wind_direction = " + wind_direction)
	
func set_wind_strength(value):
	wind_strength = value
	
	particles.process_material.set_shader_param("initial_linear_velocity", wind_strength)
	particles.process_material.set_shader_param("angular_velocity", wind_strength)
	particles.process_material.set_shader_param("linear_accel", wind_strength)
	
func set_particle_amount(value):
	particle_amount = int(value)
	particles.process_material.set_shader_param("number_particles_shown", particle_amount)
		
func modulate_wind(start_value_wind, start_value_particles):
	var end_value_wind = rand_range(-160, 160)
	prints("end_value_wind: " + str(end_value_wind))
	
	if end_value_wind < 0:
		wind_direction = "left"
		self.wind_direction = wind_direction
	elif end_value_wind >= 0:
		wind_direction = "right"
		self.wind_direction = wind_direction
		
	if end_value_wind < 64 && end_value_wind > -64 && start_value_particles != 100:
		end_value_particles = 100
		print("weak wind; less sand")
		tween.interpolate_property(self, "particle_amount",
		start_value_particles, end_value_particles, 4,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		$AnimationPlayer.play("Calm")
		
#		Player1Stats.status = "not_slow"
#		Player2Stats.status = "not_slow"
		
	elif (end_value_wind > 64 || end_value_wind < -64) && start_value_particles != 6000:
		end_value_particles = 6000
		print("strong wind; more sand")
		tween.interpolate_property(self, "particle_amount",
		start_value_particles, end_value_particles, 8,
		Tween.TRANS_LINEAR, Tween.EASE_IN)
		$AnimationPlayer.play("Storm")
		
#		Player1Stats.status = "slow"
#		Player2Stats.status = "slow"
		
	else: # pass
		print('not changing sand amount')
		
	tween.interpolate_property(self, "wind_strength",
		start_value_wind, end_value_wind, 4,
		Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func _on_Timer_timeout():
	current_wind_strength = wind_strength
	current_particles_amount = particles.process_material.get_shader_param("number_particles_shown")
	modulate_wind(current_wind_strength, current_particles_amount)
	$Timer.start(10)
