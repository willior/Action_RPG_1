extends TextureRect

var current_formula
var a
var b

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
		$Icon.frames = null
		$Label.hide()
		return
	
	for n in get_children():
		if !n.visible: n.visible = true
	$Icon.frames = new_selected_formula.formula_reference.icon
	$Icon.frame = 0
	update_formula_quantity(current_formula)
	
func _on_ingredient_quantity_updated(_ingredient):
	update_formula_quantity(current_formula)

func update_formula_quantity(selected_formula):
	var ingredients = get_node("/root/World/YSort/Player").pouch.get_ingredients()
	var ingredients_needed = selected_formula.formula_reference.cost.keys()
	var quantity_needed = selected_formula.formula_reference.cost.values()
	a = 0
	b = 0
	for i in range(ingredients.size()):
		if ingredients[i].ingredient_reference.name == ingredients_needed[0] && ingredients[i].quantity >= quantity_needed[0]:
			a = ingredients[i].quantity / quantity_needed[0]
			continue
		if ingredients[i].ingredient_reference.name == ingredients_needed[1] && ingredients[i].quantity >= quantity_needed[1]:
			b = ingredients[i].quantity / quantity_needed[1]
			continue
	var formula_quantity = min(a, b)
	$Label.text = str(formula_quantity)
	a = 0
	b = 0
