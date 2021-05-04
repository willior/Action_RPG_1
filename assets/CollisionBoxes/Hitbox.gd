extends Area2D

var knockback_vector = Vector2.ZERO
var player = null

export(float) var damage = 1
export var randomness = 0.16
export(float) var accuracy = 1
export var formula = false
export(float) var crit_chance = 5
export(Array) var status
