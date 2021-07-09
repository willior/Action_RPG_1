extends Node

var growth_rate = 50
var Hardball = ["Hardball", 1, 0, 100, 0]
var Flash = ["Flash", 1, 0, 100, 0]

var Heal = ["Heal", 1, 0, 100, 0]
var Cleanse = ["Cleanse", 1, 0, 100, 0]

var Quicken = ["Quicken", 1, 0, 100, 0]
var Fury = ["Fury", 1, 0, 100, 0]

# formula_data[0] = name
# formula_data[1] = level
# formula_data[2] = xp
# formula_data[3] = xp_required
# formula_data[4] = xp_total
func apply_xp_to_formula(formula_name, who):
	var formula_data = get(formula_name)
	formula_data[2] += growth_rate
	formula_data[4] += growth_rate
	# print(formula_name, " Lv.", formula_data[1], ": ", formula_data[2], " / ", formula_data[3], " XP. total: ", formula_data[4])
	while formula_data[2] >= formula_data[3]:
		formula_data[1] += 1
		formula_data[2] -= formula_data[3]
		formula_data[3] *= 1.2
		formula_data[3] = round(formula_data[3])
		# show_formula_level_notice(formula_data, who)
		# yield(get_tree().create_timer(1), "timeout")
		Global.display_message_popup(who, str(formula_data[0], " is now level " + str(formula_data[1])), "level")

# func show_formula_level_notice(formula_data, who):
	# var messagePopup = MessagePopup.instance()
	# messagePopup.message = str(formula_data[0], " is now level " + str(formula_data[1]))
	# get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(messagePopup)
	# messagePopup.level_flash()

func default_formula_data():
	Hardball = ["Hardball", 1, 0, 100, 0]
	Flash = ["Flash", 1, 0, 100, 0]
	Heal = ["Heal", 1, 0, 100, 0]
	Cleanse = ["Cleanse", 1, 0, 100, 0]
	Quicken = ["Quicken", 1, 0, 100, 0]
	Fury = ["Fury", 1, 0, 100, 0]
