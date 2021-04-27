extends Control

var current_formula
var a
var b
var ingredient_1_texture
var ingredient_2_texture
var ingredient_1_quantity
var ingredient_2_quantity
func _init():
	# warning-ignore:return_value_discarded
	GameManager.connect("player_initialized", self, "_on_player_initialized")
# warning-ignore:return_value_discarded
	GameManager.connect("player_reinitialized", self, "_on_player_initialized")
	
func _on_player_initialized(player):
	player.formulabook.connect("current_selected_formula_changed", self, "_on_current_selected_formula_changed")
	player.pouch.connect("ingredient_quantity_updated", self, "_on_ingredient_quantity_updated")

func _on_current_selected_formula_changed(new_selected_formula):
	current_formula = new_selected_formula
	if new_selected_formula == null:
		hide()
		return
	if !visible: show()
	$FormulaRect/Icon.frames = new_selected_formula.formula_reference.icon
	$FormulaRect/Icon.frame = 0
	update_formula_quantity(current_formula)

func _on_ingredient_quantity_updated(_ingredient):
	update_formula_quantity(current_formula)

func update_formula_quantity(selected_formula):
	if selected_formula == null: return
	var ingredients = get_node("/root/World/YSort/Player").pouch.get_ingredients()
	var ingredients_needed = selected_formula.formula_reference.cost.keys()
	var quantity_needed = selected_formula.formula_reference.cost.values()
	a = 0
	b = 0
	for i in range(ingredients.size()):
		if ingredients[i].ingredient_reference.name == ingredients_needed[0]: # && ingredients[i].quantity >= quantity_needed[0]:
			a = ingredients[i].quantity / quantity_needed[0]
			ingredient_1_quantity = ingredients[i].quantity
			continue
		if ingredients[i].ingredient_reference.name == ingredients_needed[1]: # && ingredients[i].quantity >= quantity_needed[1]:
			b = ingredients[i].quantity / quantity_needed[1]
			ingredient_2_quantity = ingredients[i].quantity
			continue
	var formula_quantity = min(a, b)
	a = 0
	b = 0
	$FormulaRect/Label.text = str(formula_quantity)
	$IngredientsRect/Ingredient1.texture = selected_formula.formula_reference.ing_1_icon
	$IngredientsRect/Ingredient2.texture = selected_formula.formula_reference.ing_2_icon
	if ingredient_1_quantity: $IngredientsRect/Quantity1.text = str(ingredient_1_quantity)
	else: $IngredientsRect/Quantity1.text = str(0)
	if ingredient_2_quantity: $IngredientsRect/Quantity2.text = str(ingredient_2_quantity)
	else: $IngredientsRect/Quantity2.text = str(0)
	ingredient_1_quantity = 0
	ingredient_2_quantity = 0
