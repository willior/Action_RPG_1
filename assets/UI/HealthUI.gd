extends Control

var health = PlayerStats.health setget set_health
var max_health = PlayerStats.max_health setget set_max_health

onready var healthBar = $HealthTexture
onready var healthBack = $HealthBack
	
func set_health(value):
	var old_health = health
	health = value
	healthBar.value = health
	if old_health < health:
		reset_health_background()
	else:
		set_health_background(health)

func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health
	healthBar.rect_size.x = max_health
	healthBack.max_value = max_health
	healthBack.rect_size.x = max_health
	
func set_health_background(value):
	if healthBack.value > value:
		$Timer.start()
		yield($Timer, "timeout")
		health_tick()
	else:
		reset_health_background()
		
func reset_health_background():
	if healthBack.value > healthBar.value:
		return
	else:
		healthBack.value = healthBar.value
		
func health_tick():
	if healthBack.value > health:
		healthBack.value -= 1
		PlayerStats.final_health = healthBack.value
		$Timer.start()
		yield($Timer, "timeout")
		health_tick()
	elif healthBack.value == 0 && !PlayerStats.dead:
		PlayerStats.dead = true
	
func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health") # connecting to the "health_changed" signal to the UI, connecting the value passed to the "set_health" function
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
