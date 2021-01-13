extends Control

var health setget set_health
var max_health setget set_max_health

onready var healthBar = $HealthTexture
onready var healthBack = $HealthBack
	
func set_health(value):
	health = value
	healthBar.value = health
	set_health_background(health)
	
func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health
	healthBar.rect_size.x = max_health
	healthBack.max_value = max_health
	healthBack.rect_size.x = max_health
	
func set_health_background(value):
	if healthBack.value > value:
		healthBack.value -= 1
		$Timer.start()
		yield($Timer, "timeout")
		set_health_background(value)
	else:
		healthBack.value = value
	
func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health") # connecting to the "health_changed" signal to the UI, connecting the value passed to the "set_health" function
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
