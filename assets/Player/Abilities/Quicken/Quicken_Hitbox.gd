extends Area2D
export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var spell_mod # = get_parent().player.stats.spell_mod
var formula_level
var duration : float
var potency : float
var knockback_vector = Vector2.ZERO
var status = ["Haste", 1.0]

func _ready():
	spell_mod = get_parent().player.stats.spell_mod
	formula_level = get_parent().player.formulaData.get(formula_name)[1]
	duration = 12.0 + formula_level # duration is 12 seconds + the Formula Level
	potency = min(spell_mod, 1.5) # Potency is the spell_mod or 1.5, whichever is lower
	print("haste potency (speed_mod modifier): ", potency)
	status.append(duration)
	status.append(potency)
	# potency = (base_potency*formula_level_mod) * (spell_mod*spell_mod)
	# amount = Global.random_variance(potency, randomness)
	# print('heal amount: ', base_potency, " * ", formula_level_mod, " * ", spell_mod*spell_mod, " = ", potency)
