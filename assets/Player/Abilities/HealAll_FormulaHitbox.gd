extends Area2D

export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var magic_mod = PlayerStats.magic_mod
var formula_level_mod
var potency
var knockback_vector = Vector2.ZERO
var formula = true

func _ready():
	formula_level_mod = FormulaStats.get(formula_name)[1]
	potency = base_potency * (magic_mod*magic_mod) * formula_level_mod
	
	# maybe: (base_damage*formula_level_mod) * (magic_mod*magic_mod)
	
	print('calculating formula potency: base_potency * magic_mod^2 * formula_level_mod')
	print(base_potency, " * ", magic_mod*magic_mod, " * ", formula_level_mod)
	print('formula potency (before calculation) = ', potency)
