extends Area2D

onready var damage = PlayerStats.strength setget set_strength
var knockback_vector = Vector2.ZERO

func set_strength(strength):
	damage = PlayerStats.strength

func _ready():
	PlayerStats.connect("strength_changed", self, "set_strength")
