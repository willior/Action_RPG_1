extends Resource
class_name FormulaBook
# FormulaBook

signal formulabook_changed
signal current_selected_formula_changed

export var _formulas = Array() setget set_formulas, get_formulas

var current_selected_formula = 0

func set_formulas(new_formulas):
	_formulas = new_formulas
	emit_signal("formulabook_changed", self)
	if _formulas.size() <= 0:
		return
	var new_selected_formula = get_formula(current_selected_formula)
	emit_signal("current_selected_formula_changed", new_selected_formula)

func get_formulas():
	return _formulas

func get_formula(index):
	return _formulas[index]

func advance_selected_formula():
	if _formulas.size() <= 1:
		GameManager.player.bamboo.play()
#		var new_selected_formula = get_formula(current_selected_formula)
#		emit_signal("current_selected_formula_changed", new_selected_formula)

	else:
		SoundPlayer.play_sound("miss")
		current_selected_formula += 1
		if current_selected_formula >= _formulas.size():
			current_selected_formula = 0
		var new_selected_formula = get_formula(current_selected_formula)
		emit_signal("current_selected_formula_changed", new_selected_formula)
		
func previous_selected_formula():
	if _formulas.size() <= 1:
		GameManager.player.bamboo.play()

	else:
		SoundPlayer.play_sound("miss")
		current_selected_formula -= 1
		if current_selected_formula < 0:
			current_selected_formula = _formulas.size() - 1
		var new_selected_formula = get_formula(current_selected_formula)
		emit_signal("current_selected_formula_changed", new_selected_formula)
	
func check_formula(formula_name):
	var formula = FormulaDatabase.get_formula(formula_name)
	if not formula:
		print("could not find formula")
		return
		
	return formula

# warning-ignore:unused_argument
func use_formula(who):
	var used_formula = check_formula(_formulas[current_selected_formula].formula_reference.name)
	if used_formula:
		pass
		# FormulaHandler.formula_handler(used_formula, who)

func remove_formula(formula_name):
	for i in range(_formulas.size()):
		var formulabook_formula = _formulas[i]
		if formulabook_formula.formula_reference.name != formula_name:
			continue
		else: 
			prints(str(formulabook_formula.formula_reference.name) + " cleared from formulabook")
			if current_selected_formula == i:
				previous_selected_formula()
			_formulas.erase(get_formula(i))
			if _formulas.size() <= 0:
				emit_signal("current_selected_formula_changed", null)
			return
		# warning-ignore:unused_variable
		# var updated_selected_formula = get_formula(current_selected_formula)

func add_formula(formula_name):
	prints("adding formula: " + str(formula_name))
	var formula = check_formula(formula_name)
	var new_formula = {
		formula_reference = formula
	}
	for i in range(_formulas.size()):
		var formulabook_formula = _formulas[i]
		if formulabook_formula.formula_reference.name == formula_name:
			print(formula_name, ' already in book. returning.')
			return
	_formulas.append(new_formula)
	print('added ', formula_name, ' to book.')
	current_selected_formula = _formulas.size()
	if current_selected_formula >= _formulas.size():
		current_selected_formula = 0
	var new_selected_formula = get_formula(current_selected_formula)
	emit_signal("current_selected_formula_changed", new_selected_formula)
