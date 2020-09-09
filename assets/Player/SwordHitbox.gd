extends "res://assets/CollisionBoxes/Hitbox.gd"

func set_strength(strength):
	self.damage = strength
	print(strength)

func _ready():
	PlayerStats.connect("strength_changed", self, "set_strength")
