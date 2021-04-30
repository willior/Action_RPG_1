extends Control
var Label_Item = load("res://assets/UI/Menu/LabelItem.tscn")
var Formula_Item = load("res://assets/UI/Menu/FormulaItem.tscn")
var Formula_XP = load("res://assets/UI/Menu/FormulaXP.tscn")
var Formula_Button = load("res://assets/UI/Menu/FormulaButton.tscn")
const AudioMove = preload("res://assets/Audio/cursLo.wav")
const AudioSelect = preload("res://assets/Audio/cursHi.wav")
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
var status = false

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
		var formula_data = FormulaStats.get(alchemy_formula.formula_reference.name)
		var formula_item = Formula_Item.instance()
		var ingredients_needed = alchemy_formula.formula_reference.cost.values()
		formula_item.formula_name = alchemy_formula.formula_reference.name
		formula_item.formula_level = formula_data[1]
		formula_item.ing_1_icon = alchemy_formula.formula_reference.ing_1_icon
		formula_item.ing_1_cost = ingredients_needed[0]
		formula_item.ing_2_icon = alchemy_formula.formula_reference.ing_2_icon
		formula_item.ing_2_cost = ingredients_needed[1]
		formula_item.formula_icon = alchemy_formula.formula_reference.icon
		$AlchemyDisplay/Vbox.add_child(formula_item)
		
		var formula_xp = Formula_XP.instance()
		formula_xp.current_xp = formula_data[2]
		formula_xp.required_xp = formula_data[3]
		$AlchemyDisplay/Vbox.add_child(formula_xp)
		
		var formula_button = Formula_Button.instance()
		$AlchemyDisplay/VBoxButtons.add_child(formula_button)
		$AlchemyDisplay/Vbox.add_child(Control.new())
	
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
	$AlchemyDisplay.hide()
	$AudioMenu.stream = AudioMove
	$AudioMenu.play()

func _on_ButtonStatus_pressed():
	$AudioMenu.stream = AudioSelect
	$AudioMenu.play()
	status = true
	$StatsDisplay/VBoxButtons/ButtonVIT.grab_focus()

func _on_ButtonStatus_focus_exited():
	pass

func _on_ButtonSTAT_gui_input(event):
	if event.is_action_pressed("ui_cancel"):
		$MenuPanel/Menu/ButtonStatus.grab_focus()
	if event.is_action_pressed("ui_select"):
		audio_menu_select()

func _on_ButtonAlchemy_focus_entered():
	$StatsDisplay.hide()
	$AlchemyDisplay.show()
	audio_menu_move()

func _on_ButtonAlchemy_pressed():
	$AudioMenu.stream = AudioSelect
	$AudioMenu.play()
	if $AlchemyDisplay/VBoxButtons.get_child_count() < 1:
		return
	else:
		$AlchemyDisplay/VBoxButtons.get_child(0).grab_focus()

func _on_ButtonAlchemy_focus_exited():
	pass

func _on_ButtonPouch_focus_entered():
	$PouchDisplay.show()
	$AlchemyDisplay.hide()
	audio_menu_move()

func _on_ButtonPouch_focus_exited():
	$PouchDisplay.hide()

func _on_ButtonControls_focus_entered():
	$ControlsDisplay.show()
	audio_menu_move()

func _on_ButtonControls_focus_exited():
	$ControlsDisplay.hide()

func _on_ButtonPouch_pressed():
	audio_menu_select()

func _on_ButtonControls_pressed():
	audio_menu_select()
	
func audio_menu_move():
	$AudioMenu.stream = AudioMove
	$AudioMenu.play()
	
func audio_menu_select():
	$AudioMenu.stream = AudioSelect
	$AudioMenu.play()

#func _on_ButtonInventory_focus_entered():
#	return
## warning-ignore:unreachable_code
#	$InventoryDisplay.show()
#	audio_menu_move()
#
#func _on_ButtonInventory_focus_exited():
#	return
## warning-ignore:unreachable_code
#	$InventoryDisplay.hide()
	
