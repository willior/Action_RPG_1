extends Area2D

onready var damage = PlayerStats.strength setget set_strength
var knockback_vector = Vector2.ZERO
var orig

func _ready():
	PlayerStats.connect("strength_changed", self, "set_strength")

func set_strength(strength):
	damage = PlayerStats.strength

func shade_start():
	orig = damage
	damage += 4
	prints('shade damage: ' + str(damage))
	
func shade_end():
	damage = orig
	prints('reverting to original damage ' + str(damage))
