extends Node

const MessagePopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
var growth_rate = 50
var Flash = ["Flash", 1, 0, 100, 0]
var Heal = ["Heal", 1, 0, 100, 0]
var Fury = ["Fury", 1, 0, 100, 0]
# formula_data[0] = name
# formula_data[1] = level
# formula_data[2] = xp
# formula_data[3] = xp_required
# formula_data[4] = xp_total
func apply_xp_to_formula(formula_name):
	var formula_data = get(formula_name)
	formula_data[2] += growth_rate
	formula_data[4] += growth_rate
	while formula_data[2] >= formula_data[3]:
		formula_data[1] += 1
		formula_data[2] -= formula_data[3]
		formula_data[3] *= 1.2
		show_formula_level_notice(formula_data)

func show_formula_level_notice(formula_data):
	var messagePopup = MessagePopup.instance()
	messagePopup.message = str(formula_data[0], " is now level " + str(formula_data[1]))
	
	yield(get_tree().create_timer(1), "timeout")
	get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
	messagePopup.level_flash()
