extends Area2D

var base_damage = 4.0
var magic_mod = PlayerStats.magic_mod
var spell_level_mod = 1.0
var damage
var randomness = 0.1
var knockback_vector = Vector2.ZERO
var spell = true

func _ready():
	damage = base_damage * (magic_mod*magic_mod) * spell_level_mod
	
	print('calculating spell damage: base_damage * (magic_mod*magic_mod) * spell_level_mod')
	print(base_damage, " * ", magic_mod*magic_mod, " * ", spell_level_mod)
	print('spell damage = ', damage)
