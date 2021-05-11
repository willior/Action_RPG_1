extends Area2D

export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var magic_mod = PlayerStats.magic_mod
var formula_level_mod
var potency
var amount
var knockback_vector = Vector2.ZERO
var formula = true
var healing = true

func _ready():
	formula_level_mod = FormulaStats.get(formula_name)[1]
	potency = (base_potency*formula_level_mod) * (magic_mod*magic_mod)
	amount = Global.random_variance(potency, randomness)
	print('heal amount: ', base_potency, " * ", formula_level_mod, " * ", magic_mod*magic_mod, " = ", potency)
