extends Node

var max_health = 66 setget set_max_health
var health = max_health setget set_health
var defense = 2.0
var status_resistance = 0.0
var evasion = 12
var experience_pool = 378
var affinity = 8 # Dark

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	health = clamp(value, 0, max_health)
	emit_signal("health_changed", health) # every time the health is set, emits a signal "health_changed" along with an argument, our new health value
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
