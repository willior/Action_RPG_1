extends Area2D
export(String) var formula_name
export(float) var base_potency
export(float) var randomness
var spell_mod # = get_parent().player.stats.spell_mod
var formula_level
var duration
var potency
var knockback_vector = Vector2.ZERO
var status = ["Regen", 1]
var element = 9
var formula = true

func _ready():
	spell_mod = get_parent().player.stats.spell_mod
	formula_level = get_parent().player.formulaData.get(formula_name)[1]
	duration = 16 + (formula_level*2)
	potency = (base_potency*formula_level) * (spell_mod*spell_mod)
	status.append(duration) # status duration
	status.append(int(formula_level+spell_mod*spell_mod)) # status potency
