extends Node

var formulas = Array()

func _ready():
	var directory = Directory.new()
	directory.open("res://assets/Resources/FormulaResources")
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			formulas.append(load("res://assets/Resources/FormulaResources/%s" % filename))
			
		filename = directory.get_next()

func get_formula(formula_name):
	for i in formulas:
		if i.name == formula_name:
			return i
	
	return null
