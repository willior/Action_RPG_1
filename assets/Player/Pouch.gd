extends Resource
# class_name Pouch

signal pouch_changed
signal ingredient_quantity_updated
signal ingredient_quantity_zero
export var _ingredients = Array() setget set_ingredients, get_ingredients

func set_ingredients(new_ingredients):
	_ingredients = new_ingredients
	emit_signal("pouch_changed", self)

func get_ingredients():
	return _ingredients

func get_ingredient(index):
	return _ingredients[index]

func check_ingredient(ingredient_name, quantity):
	if quantity <= 0:
		GameManager.player.audio.stream = load("res://assets/Audio/Bamboo.wav")
		GameManager.player.audio.play()
		return
	
	var ingredient = IngredientDatabase.get_ingredient(ingredient_name)
	if not ingredient:
		print("could not find ingredient")
		return
	return ingredient

func remove_ingredient(ingredient_name, quantity):
	for i in range(_ingredients.size()):
		var inventory_ingredient = _ingredients[i]
		if inventory_ingredient.ingredient_reference.name != ingredient_name:
			continue
		if (inventory_ingredient.quantity-quantity) < 0:
			print("none left / not enough ingredients")
			return
		else: 
			inventory_ingredient.quantity -= quantity
			if inventory_ingredient.quantity <= 0:
				emit_signal("ingredient_quantity_updated", get_ingredient(i))
				emit_signal("ingredient_quantity_zero", inventory_ingredient.ingredient_reference.name)
				prints(str(inventory_ingredient.ingredient_reference.name) + " cleared from pouch")
				_ingredients.erase(get_ingredient(i))
				return
			else:
				emit_signal("ingredient_quantity_updated", get_ingredient(i))

func add_ingredient(ingredient_name, quantity):
	prints("adding " + str(quantity) + " " + str(ingredient_name))
	var ingredient = check_ingredient(ingredient_name, quantity)
	for i in range(_ingredients.size()):
		var inventory_ingredient = _ingredients[i]
		if inventory_ingredient.ingredient_reference.name != ingredient_name:
			continue
		if inventory_ingredient.quantity+quantity > ingredient.max_stack_size:
			print("max stack (", ingredient.max_stack_size, ") reached; discarding extras (", ingredient.max_stack_size-(inventory_ingredient.quantity+quantity), ")")
			inventory_ingredient.quantity = ingredient.max_stack_size
			emit_signal("ingredient_quantity_updated", get_ingredient(i))
			return
		else: 
			inventory_ingredient.quantity += quantity
			quantity = 0
		emit_signal("ingredient_quantity_updated", get_ingredient(i))
	
	if quantity > 0:
		var new_ingredient = {
			ingredient_reference = ingredient,
			quantity = quantity
		}
		_ingredients.append(new_ingredient)
		quantity = 0
		for i in range(_ingredients.size()):
			var inventory_ingredient = _ingredients[i]
			if inventory_ingredient.ingredient_reference.name != ingredient_name:
				continue
			emit_signal("ingredient_quantity_updated", get_ingredient(i))
