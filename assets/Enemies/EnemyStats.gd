extends Node

export var max_health : int setget set_max_health
var health = max_health setget set_health
export var defense : float
export var status_resistance : float
export var base_evasion : int
var evasion : float
export var speed_mod : float = 1.0 setget set_speed_mod
export var experience_pool : int
export var affinity : int

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
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_speed_mod(value):
	speed_mod = value
	evasion = base_evasion*speed_mod
	get_parent().set_speed_scale()

func _ready():
	self.health = max_health
	self.evasion = base_evasion*speed_mod
