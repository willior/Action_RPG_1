extends Area2D

# duration is 3 seconds + formula_level/2 seconds
# potency is 2 or magic_mod, whichever is less

export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var magic_mod # = get_parent().player.stats.magic_mod
var formula_level
var duration
var potency
var knockback_vector = Vector2.ZERO

var status = ["Frenzy", 1.0]
var buff = true

func _ready():
	magic_mod = get_parent().player.stats.magic_mod
	formula_level = get_parent().player.formulaData.get(formula_name)[1]
	duration = 3.0 + formula_level/2.0
	potency = min(magic_mod, 2)
	status.append(duration)
	status.append(potency)
	
	# potency = (base_potency*formula_level_mod) * (magic_mod*magic_mod)
	# amount = Global.random_variance(potency, randomness)
	# print('heal amount: ', base_potency, " * ", formula_level_mod, " * ", magic_mod*magic_mod, " = ", potency)
