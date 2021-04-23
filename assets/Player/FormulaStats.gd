extends Node

const PickupPopup = preload("res://assets/UI/Popups/PickupPopup.tscn")

var growth_rate = 50

var flash_level = 1 # setget set_flash_level
var flash_xp_total = 0
var flash_xp = 0 # setget set_flash_xp
var flash_xp_required = 100 # setget set_flash_xp_required
var flash_data = [
	"Flash",
	flash_level,
	flash_xp,
	flash_xp_required,
	flash_xp_total,
]

var heal_level = 1
var heal_xp = 0 # setget set_heal_xp
var heal_xp_required = 100 # setget set_heal_xp_required
var heal_xp_total = 0
var heal_data = [
	"Heal",
	heal_level,
	heal_xp,
	heal_xp_required,
	heal_xp_total,
]

# formula_data[0] = name : String
# formula_data[1] = level
# formula_data[2] = xp
# formula_data[3] = xp_required
# formula_data[4] = xp_total
func formula_used(formula_data):
	formula_data[2] += growth_rate
	formula_data[4] += growth_rate
	while formula_data[2] >= formula_data[3]:
		formula_data[1] += 1
		formula_data[2] -= formula_data[3]
		formula_data[3] *= 1.2
		var pickupPopup = PickupPopup.instance()
		pickupPopup.pickupDisplay = str(formula_data[0], " is now level " + str(formula_data[1]))
		get_node("/root/World/GUI/PickupDisplay1/PickupContainer").add_child(pickupPopup)
	print('flash xp: ', flash_xp, "/", flash_xp_required)
	
	return
	match formula_data:
		"Flash":
			flash_xp += growth_rate
			flash_xp_total += growth_rate
			while flash_xp >= flash_xp_required:
				flash_level += 1
				flash_xp -= flash_xp_required
				flash_xp_required *= 1.2
				var pickupPopup = PickupPopup.instance()
				pickupPopup.pickupDisplay = "Flash is now level " + str(flash_level)
				get_node("/root/World/GUI/PickupDisplay1/PickupContainer").add_child(pickupPopup)
			print('flash xp: ', flash_xp, "/", flash_xp_required)
		"Heal":
			heal_xp += growth_rate
			heal_xp_total += growth_rate
			while heal_xp >= heal_xp_required:
				heal_level += 1
				heal_xp -= heal_xp_required
				heal_xp_required *= 1.2
				var pickupPopup = PickupPopup.instance()
				pickupPopup.pickupDisplay = "Heal is now level " + str(heal_level)
				get_node("/root/World/GUI/PickupDisplay1/PickupContainer").add_child(pickupPopup)
			print('heal xp: ', heal_xp, "/", heal_xp_required)

func set_flash_level(value):
	flash_level = value

func set_flash_xp(value):
	flash_xp = value

func set_flash_xp_required(value):
	flash_xp_required = value
	
func set_heal_level(value):
	heal_level = value

func set_heal_xp(value):
	heal_xp = value

func set_heal_xp_required(value):
	heal_xp_required = value
