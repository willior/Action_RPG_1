extends Area2D

var formula_name = "flash"
var base_damage = 4.0
var magic_mod = PlayerStats.magic_mod
var spell_level_mod
var damage
var randomness = 0.1
var knockback_vector = Vector2.ZERO
var spell = true

func _ready():
	spell_level_mod = FormulaStats.flash_level
	damage = base_damage * (magic_mod*magic_mod) * spell_level_mod
	
	# maybe: (base_damage*spell_level_mod) * (magic_mod*magic_mod)
	
	print('calculating spell damage: base_damage * magic_mod^2 * spell_level_mod')
	print(base_damage, " * ", magic_mod*magic_mod, " * ", spell_level_mod)
	print('spell damage (before calculation) = ', damage)
	
