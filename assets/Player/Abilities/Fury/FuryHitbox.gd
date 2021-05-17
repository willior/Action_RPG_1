extends Area2D

# duration is 3 seconds + formula_level/2 seconds
# potency is 2 or magic_mod, whichever is less

export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var magic_mod = PlayerStats.magic_mod
var formula_level
var duration
var potency
var knockback_vector = Vector2.ZERO
var formula = true
var buff = true

func _ready():
	formula_level = FormulaStats.get(formula_name)[1]
	duration = 3.0 + formula_level/2.0
	potency = min(magic_mod, 2)
	get_parent().status.append(duration)
	get_parent().status.append(potency)
	
	# potency = (base_potency*formula_level_mod) * (magic_mod*magic_mod)
	# amount = Global.random_variance(potency, randomness)
	# print('heal amount: ', base_potency, " * ", formula_level_mod, " * ", magic_mod*magic_mod, " = ", potency)
