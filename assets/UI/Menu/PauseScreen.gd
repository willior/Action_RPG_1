extends Control
var Label_Item = load("res://assets/UI/Menu/LabelItem.tscn")
onready var healthBox = $StatsDisplay/Vbox/vit
onready var enduranceBox = $StatsDisplay/Vbox/end
onready var defenseBox = $StatsDisplay/Vbox/def
onready var strengthBox = $StatsDisplay/Vbox/str
onready var dexterityBox = $StatsDisplay/Vbox/dex
onready var speedBox = $StatsDisplay/Vbox/spd

func _ready():
	healthBox.set_text("VIT " + str(PlayerStats.vitality) + " (" + str(PlayerStats.health) + "/" + str(PlayerStats.max_health) + "HP)")
	enduranceBox.set_text("END " + str(PlayerStats.endurance))
	defenseBox.set_text("DEF " + str(PlayerStats.defense))
	strengthBox.set_text("STR " + str(PlayerStats.strength))
	dexterityBox.set_text("DEX " + str(PlayerStats.dexterity))
	speedBox.set_text("SPD " + str(PlayerStats.speed))
	
	var player = get_node("/root/World/YSort/Player")
	
	for i in player.inventory.get_items().size():
		var inventory_item = player.inventory.get_item(i)
		var label_item = Label_Item.instance()
		if inventory_item.item_reference.type == 0: # if item is consumable, show quantity
			label_item.set_text(str(inventory_item.item_reference.name) + " x" + str(inventory_item.quantity))
		else:
			label_item.set_text(str(inventory_item.item_reference.name))
		$InventoryDisplay/Vbox.add_child(label_item)

	for n in player.pouch.get_ingredients().size():
		var pouch_ingredient = player.pouch.get_ingredient(n)
		
		var label_ingredient = Label_Item.instance()
		label_ingredient.set_text(str(pouch_ingredient.ingredient_reference.name) + " x" + str(pouch_ingredient.quantity))
		$PouchDisplay/Vbox.add_child(label_ingredient)
		
		var icon_ingredient = TextureRect.new()
		icon_ingredient.set_texture(pouch_ingredient.ingredient_reference.texture)
		$PouchDisplay/VBoxIcons.add_child(icon_ingredient)
		
	$TimerDelaySelect.start()
	yield($TimerDelaySelect, "timeout")
	$MenuPanel/Menu/ButtonStatus.grab_focus()
	

func _on_ButtonStatus_focus_entered():
	$StatsDisplay.show()
	$AudioMenu.play()
	
func _on_ButtonStatus_focus_exited():
	$StatsDisplay.hide()

func _on_ButtonInventory_focus_entered():
	$InventoryDisplay.show()
	$AudioMenu.play()
	
func _on_ButtonInventory_focus_exited():
	$InventoryDisplay.hide()
	
func _on_ButtonPouch_focus_entered():
	$PouchDisplay.show()
	$AudioMenu.play()

func _on_ButtonPouch_focus_exited():
	$PouchDisplay.hide()

func _on_ButtonControls_focus_entered():
	$ControlsDisplay.show()
	$AudioMenu.play()

func _on_ButtonControls_focus_exited():
	$ControlsDisplay.hide()
