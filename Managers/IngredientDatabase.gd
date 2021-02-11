extends Node

var ingredients = Array()

func _ready():
	var directory = Directory.new()
	directory.open("res://assets/Resources/IngredientResources")
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			ingredients.append(load("res://assets/Resources/IngredientResources/%s" % filename))
			
		filename = directory.get_next()

func get_ingredient(ingredient_name):
	for i in ingredients:
		if i.name == ingredient_name:
			return i
	
	return null
