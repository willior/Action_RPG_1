extends Control
var Label_Item = load("res://assets/UI/Menu/LabelItem.tscn")
var Formula_Item = load("res://assets/UI/Menu/FormulaItem.tscn")
onready var healthBox = $StatsDisplay/VBox/HBox/vit
onready var enduranceBox = $StatsDisplay/VBox/HBox2/end
onready var defenseBox = $StatsDisplay/VBox/HBox3/def
onready var strengthBox = $StatsDisplay/VBox/HBox4/str
onready var dexterityBox = $StatsDisplay/VBox/HBox5/dex
onready var speedBox = $StatsDisplay/VBox/HBox6/spd
onready var magicBox = $StatsDisplay/VBox/HBox7/mag
onready var vitBar = $StatsDisplay/VBox/ColorRect1
onready var endBar = $StatsDisplay/VBox/ColorRect2
onready var defBar = $StatsDisplay/VBox/ColorRect3
onready var strBar = $StatsDisplay/VBox/ColorRect4
onready var dexBar = $StatsDisplay/VBox/ColorRect5
onready var spdBar = $StatsDisplay/VBox/ColorRect6
onready var magBar = $StatsDisplay/VBox/ColorRect7

func _ready():
	healthBox.set_text(str(PlayerStats.vitality)) # + " (" + str(PlayerStats.health) + "/" + str(PlayerStats.max_health) + "HP)")
	enduranceBox.set_text(str(PlayerStats.endurance))
	defenseBox.set_text(str(PlayerStats.defense))
	strengthBox.set_text(str(PlayerStats.strength))
	dexterityBox.set_text(str(PlayerStats.dexterity))
	speedBox.set_text(str(PlayerStats.speed))
	magicBox.set_text(str(PlayerStats.magic))
	vitBar.value = PlayerStats.vitality
	endBar.value = PlayerStats.endurance
	defBar.value = PlayerStats.defense
	strBar.value = PlayerStats.strength
	dexBar.value = PlayerStats.dexterity
	spdBar.value = PlayerStats.speed
	magBar.value = PlayerStats.magic
	var player = get_node("/root/World/YSort/Player")
	for i in player.inventory.get_items().size():
		var inventory_item = player.inventory.get_item(i)
		var label_item = Label_Item.instance()
		if inventory_item.item_reference.type == 0: # if item is consumable, show quantity
			label_item.set_text(str(inventory_item.item_reference.name) + " x" + str(inventory_item.quantity))
		else:
			label_item.set_text(str(inventory_item.item_reference.name))
		$InventoryDisplay/Vbox.add_child(label_item)
	
	for f in player.formulabook.get_formulas().size():
		var alchemy_formula = player.formulabook.get_formula(f)
		var formula_item = Formula_Item.instance()
		var ingredients_needed = alchemy_formula.formula_reference.cost.values()
		formula_item.formula_name = alchemy_formula.formula_reference.name
		formula_item.ing_1_icon = alchemy_formula.formula_reference.ing_1_icon
		formula_item.ing_1_cost = ingredients_needed[0]
		formula_item.ing_2_icon = alchemy_formula.formula_reference.ing_2_icon
		formula_item.ing_2_cost = ingredients_needed[1]
		formula_item.formula_icon = alchemy_formula.formula_reference.icon
		
		$AlchemyDisplay/Vbox.add_child(formula_item)
		
		
#		var label_formula = Label_Item.instance()
#		label_formula.set_text(str(alchemy_formula.formula_reference.name))
#		$AlchemyDisplay/Vbox.add_child(label_formula)
#		var icon_formula = AnimatedSprite.new()
#		icon_formula.play()
#		icon_formula.frames = alchemy_formula.formula_reference.icon
#		$AlchemyDisplay/Vbox.add_child(icon_formula)

		
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
	
func _on_ButtonAlchemy_focus_entered():
	$AlchemyDisplay.show()
	$AudioMenu.play()

func _on_ButtonAlchemy_focus_exited():
	$AlchemyDisplay.hide()

#func _on_ButtonInventory_focus_entered():
#	$InventoryDisplay.show()
#	$AudioMenu.play()
#
#func _on_ButtonInventory_focus_exited():
#	$InventoryDisplay.hide()

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


