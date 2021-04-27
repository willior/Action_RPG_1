extends Node

const PickupPopup = preload("res://assets/UI/Popups/PickupPopup.tscn")
var growth_rate = 50
var Flash = ["Flash", 1, 0, 100, 0]
var Heal = ["Heal", 1, 0, 100, 0]
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
		var pickupPopup = PickupPopup.instance()
		pickupPopup.pickupDisplay = str(formula_data[0], " is now level " + str(formula_data[1]))
		get_node("/root/World/GUI/PickupDisplay1/PickupContainer").add_child(pickupPopup)
	# print(formula_data[0], ' xp: ', formula_data[2], "/", formula_data[3])
