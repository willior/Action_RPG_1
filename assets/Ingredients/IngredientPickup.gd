extends Area2D

const PickupPopup = preload("res://assets/UI/Popups/MessagePopup.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const ItemCollectEffect = preload("res://assets/Effects/ItemCollectEffect.tscn")
export var ingredient_name : String
var interactable = true
var talkable = false
var examined = false
var ingredient_description : Array

func _ready():
	var ingredient = check_ingredient(ingredient_name)
	$Sprite.texture = ingredient.texture
	ingredient_description = ingredient.description
	global_position = global_position.round()

func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = ingredient_description
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true

func interact(player):
	player.state = 8
	var timer = Timer.new()
	timer.wait_time = 0.4
	add_child(timer)
	timer.start()
	yield(timer, "timeout")
	player.pouch.add_ingredient(ingredient_name, 1)
	var itemCollectEffect = ItemCollectEffect.instance()
	get_parent().add_child(itemCollectEffect)
	# argument determines sound effect; 0 = heartCollect
	itemCollectEffect.playSound(0)
	var displayMessage = "Found " + str(ingredient_name) + " x1"
	display_pickup_message(displayMessage, player.name)
	queue_free()

# warning-ignore:shadowed_variable
func check_ingredient(ingredient_name):
# warning-ignore:shadowed_variable
	var ingredient = IngredientDatabase.get_ingredient(ingredient_name)
	if not ingredient:
		print("could not find ingredient")
		return
	return ingredient

func display_pickup_message(value, who):
	var pickupPopup = PickupPopup.instance()
	pickupPopup.message = value
	match who:
		"Player":
			get_node("/root/World/GUI/MessageDisplay1/MessageContainer").add_child(pickupPopup)
		"Player2":
			get_node("/root/World/GUI/MessageDisplay2/MessageContainer").add_child(pickupPopup)
	pickupPopup.pickup_flash()
