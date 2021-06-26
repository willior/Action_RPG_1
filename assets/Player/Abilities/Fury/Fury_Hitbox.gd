extends Area2D
export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var spell_mod # = get_parent().player.stats.spell_mod
var formula_level
var duration # duration is 3 seconds + formula_level/2 seconds
var potency # potency is 2 or spell_mod, whichever is less
var knockback_vector = Vector2.ZERO
var status = ["Frenzy", 1.0]
var buff = true

func _ready():
	spell_mod = get_parent().player.stats.spell_mod
	formula_level = get_parent().player.formulaData.get(formula_name)[1]
	duration = 3.0 + formula_level/2.0
	potency = min(spell_mod, 2)
	status.append(duration)
	status.append(potency)
	# potency = (base_potency*formula_level_mod) * (spell_mod*spell_mod)
	# amount = Global.random_variance(potency, randomness)
	# print('heal amount: ', base_potency, " * ", formula_level_mod, " * ", spell_mod*spell_mod, " = ", potency)
