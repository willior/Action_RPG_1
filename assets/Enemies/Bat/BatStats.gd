extends Node

var max_health = 26 setget set_max_health
var health = max_health setget set_health
var defense = 0.0 setget set_defense
var evasion = 8
var experience_pool = 18

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

func set_defense(value):
	defense = value

func _ready():
	self.health = max_health
