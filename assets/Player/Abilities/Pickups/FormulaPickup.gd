extends Area2D

const PickupPopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")
export var formula_name : String
var interactable = true
var talkable = false
var examined = false
var formula_description : Array

func _ready():
	if formula_name in PlayerLog.examined_list:
		examined = true
	var formula = check_formula(formula_name)
	$Sprite.frames = formula.icon
	$Sprite.play()
	formula_description = formula.description
	global_position = global_position.round()

func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = formula_description
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
	PlayerLog.set_examined(formula_name)

func interact(player):
	player.state = 8
	var timer = Timer.new()
	timer.wait_time = 0.4
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	player.formulabook.add_formula(formula_name)
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	# argument determines sound effect; 0 = heartCollect
	itemCollectEffect.playSound(0)
	var displayMessage = "Acquired the " + str(formula_name) + " formula!"
	display_pickup_message(displayMessage, player.name)
	queue_free()

# warning-ignore:shadowed_variable
func check_formula(formula_name):
# warning-ignore:shadowed_variable
	var formula = FormulaDatabase.get_formula(formula_name)
	if not formula:
		print("could not find formula")
		return
	return formula

func display_pickup_message(value, who):
	var pickupPopup = PickupPopup.instance()
	pickupPopup.message = value
	match who:
		"Player":
			get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(pickupPopup)
		"Player2":
			get_node("/root/World/GUI/MessageDisplay2/MessageContainer").add_child(pickupPopup)
	pickupPopup.pickup_flash()
