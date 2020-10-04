extends Control

var health setget set_health
var max_health setget set_max_health

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty
onready var healthBar = $HealthTexture
	
func set_health(value):
	health = value
	healthBar.value = health * 15
func set_max_health(value):
	max_health = value
	healthBar.max_value = max_health * 15
	healthBar.rect_size.x = max_health * 15
	
func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_health") # connecting to the "health_changed" signal to the UI, connecting the value passed to the "set_health" function
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_health")
