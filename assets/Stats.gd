extends Node

export(int) var max_health = 4
onready var health = max_health setget set_health

signal no_health
signal health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health) # every time the health is set, emits a signal "health_changed" along with an argument, our new health value
	if health <= 0:
		emit_signal("no_health")
