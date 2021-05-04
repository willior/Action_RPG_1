extends Control

var health = PlayerStats.health setget set_health
var max_health = PlayerStats.max_health setget set_max_health

onready var healthBar = $HealthTexture
onready var healthBack = $HealthBack

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	$hp.set_text(str(health) + "/" + str(max_health))
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health") # connecting to the "health_changed" signal to the UI, connecting the value passed to the "set_health" function
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
	healthBack.value = health

func set_health(value):
	var old_health = health
	health = value
	healthBar.value = health
	if old_health < health:
		$hp.set_text(str(health) + "/" + str(max_health))
		reset_health_background()
	else:
		set_health_background(health)

func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health
	healthBar.rect_size.x = max_health/3
	healthBack.max_value = max_health
	healthBack.rect_size.x = max_health/3
	
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
		$hp.set_text(str(PlayerStats.final_health) + "/" + str(max_health))
		$Timer.start()
		yield($Timer, "timeout")
		health_tick()
	elif healthBack.value == 0 && !PlayerStats.dead:
		PlayerStats.dead = true
