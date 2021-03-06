extends Area2D

export(String) var formula_name
export(float) var base_potency
export(float) var randomness

var spell_mod
var formula_level_mod
var potency
var knockback_vector = Vector2.ZERO

var status = []
var element
# 0 : normal
# 1 : fire
# 2 : ice
# 3 : lightning
# 4 : water
# 5 : wind
# 6 : earth
# 7 : light
# 8 : dark
# 9 : verve
# 10 : entropy
var formula = true

func _ready():
	spell_mod = get_parent().player.stats.spell_mod
	formula_level_mod = get_parent().player.formulaData.get(formula_name)[1]
	potency = (base_potency*formula_level_mod) * (spell_mod*spell_mod)
