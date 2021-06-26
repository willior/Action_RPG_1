extends Area2D

export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var spell_mod = get_parent().player.stats.spell_mod
var formula_level_mod
var damage
var knockback_vector = Vector2.ZERO
var formula = true

func _ready():
	formula_level_mod = get_parent().player.formulaData.get(formula_name)[1]
	damage = base_potency * (spell_mod*spell_mod) * formula_level_mod
	
	# maybe: (base_damage*formula_level_mod) * (spell_mod*spell_mod)
	
	print('calculating formula damage: base_damage * spell_mod^2 * formula_level_mod')
	print(base_potency, " * ", spell_mod*spell_mod, " * ", formula_level_mod)
	print('formula damage (before calculation) = ', damage)
