extends Area2D

export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var magic_mod = PlayerStats.magic_mod
var formula_level
var duration
var potency
var amount
var knockback_vector = Vector2.ZERO
var element = 9
var formula
var healing = true

func _ready():
	formula_level = FormulaStats.get(formula_name)[1]
	potency = (base_potency*formula_level) * (magic_mod*magic_mod)
	amount = Global.random_variance(potency, randomness)
	# print('heal amount: ', base_potency, " * ", formula_level, " * ", magic_mod*magic_mod, " = ", potency)
	duration = 16 + (formula_level*2)
	get_parent().status.append(duration) # status duration
	get_parent().status.append(int(formula_level+magic_mod*magic_mod)) # status potency
	# print('regen status: ', get_parent().status)
