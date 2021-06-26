extends Area2D

export(String) var formula_name
export(float) var base_potency
export(float) var randomness

var spell_mod
var formula_level_mod
var potency
var knockback_vector = Vector2.ZERO

var status = ["Stun", 1.0]
var element = 7
var formula = true

func _ready():
	spell_mod = get_parent().player.stats.spell_mod
	formula_level_mod = get_parent().player.formulaData.get(formula_name)[1]
	potency = (base_potency*formula_level_mod) * (spell_mod*spell_mod)
	print('formula potency: ', base_potency, " * ", formula_level_mod, " * ", spell_mod*spell_mod, " = ", potency)
