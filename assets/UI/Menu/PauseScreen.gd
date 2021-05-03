extends Control
var Label_Item = load("res://assets/UI/Menu/LabelItem.tscn")
var Formula_Item = load("res://assets/UI/Menu/FormulaItem.tscn")
var Formula_XP = load("res://assets/UI/Menu/FormulaXP.tscn")
var Formula_Button = load("res://assets/UI/Menu/FormulaButton.tscn")
var MenuIngredient = load("res://assets/UI/Menu/MenuIngredient.tscn")
const DialogBox = preload("res://assets/UI/Dialog/PopupDialogBox.tscn")
const AudioMove = preload("res://assets/Audio/cursLo.wav")
const AudioSelect = preload("res://assets/Audio/cursHi.wav")
onready var healthBox = $StatsDisplay/VBoxButtons/ButtonVIT/HBox/VIT
onready var enduranceBox = $StatsDisplay/VBoxButtons/ButtonEND/HBox/END
onready var defenseBox = $StatsDisplay/VBoxButtons/ButtonDEF/HBox/DEF
onready var strengthBox = $StatsDisplay/VBoxButtons/ButtonSTR/HBox/STR
onready var dexterityBox = $StatsDisplay/VBoxButtons/ButtonDEX/HBox/DEX
onready var speedBox = $StatsDisplay/VBoxButtons/ButtonSPD/HBox/SPD
onready var magicBox = $StatsDisplay/VBoxButtons/ButtonMAG/HBox/MAG
onready var vitBar = $StatsDisplay/VBoxButtons/ButtonVIT/ColorRect
onready var endBar = $StatsDisplay/VBoxButtons/ButtonEND/ColorRect
onready var defBar = $StatsDisplay/VBoxButtons/ButtonDEF/ColorRect
onready var strBar = $StatsDisplay/VBoxButtons/ButtonSTR/ColorRect
onready var dexBar = $StatsDisplay/VBoxButtons/ButtonDEX/ColorRect
onready var spdBar = $StatsDisplay/VBoxButtons/ButtonSPD/ColorRect
onready var magBar = $StatsDisplay/VBoxButtons/ButtonMAG/ColorRect

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
		formula_button.description = alchemy_formula.formula_reference.description_string
		$AlchemyDisplay/VBoxButtons.add_child(formula_button)
#		if f == 0:
#			formula_button.focus_neighbour_top = $AlchemyDisplay/VBoxButtons.get_child(player.formulabook.get_formulas().size()-1).get_path()
		if player.formulabook.get_formulas().size()-1 == f:
			formula_button.focus_neighbour_bottom = $AlchemyDisplay/VBoxButtons.get_child(0).get_path()
			$AlchemyDisplay/VBoxButtons.get_child(0).focus_neighbour_top = formula_button.get_path()
		$AlchemyDisplay/Vbox.add_child(Control.new())
	
	for n in player.pouch.get_ingredients().size():
		print(n)
		print(player.pouch.get_ingredients().size()-1)
		var pouch_ingredient = player.pouch.get_ingredient(n)
		var menu_ingredient = MenuIngredient.instance()
		menu_ingredient.pouch_ingredient = pouch_ingredient
		$PouchDisplay/VBox.add_child(menu_ingredient)
#		if n == 0:
#			$MenuPanel/Menu/ButtonPouch.focus_neighbour_right = $PouchDisplay/VBox.get_child(0).get_child(0).get_path()
		if player.pouch.get_ingredients().size()-1 == n:
			menu_ingredient.get_child(0).focus_neighbour_bottom = $PouchDisplay/VBox.get_child(0).get_child(0).get_path()
			$PouchDisplay/VBox.get_child(0).get_child(0).focus_neighbour_top = menu_ingredient.get_child(0).get_path()
	
	$TimerDelaySelect.start()
	yield($TimerDelaySelect, "timeout")
	$MenuPanel/Menu/ButtonStatus.grab_focus()

func _on_PauseScreen_gui_input(event):
	get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_cancel"):
		get_tree().get_root().get_node("World").close_pause_menu()
	if event.is_action_pressed("ui_right"):
		accept_event()

func _on_ButtonStatus_focus_entered():
	$ControlsDisplay.hide()
	$AlchemyDisplay.hide()
	$StatsDisplay.hide()
	audio_menu_move()

func _on_ButtonStatus_pressed():
	$StatsDisplay.show()
	audio_menu_select()
	$StatsDisplay/VBoxButtons/ButtonVIT.grab_focus()

func _on_ButtonStatus_focus_exited():
	pass

func _on_ButtonSTAT_gui_input(event, description_index):
	if event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
		audio_menu_move()
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_left"):
		$MenuPanel/Menu/ButtonStatus.grab_focus()
	if event.is_action_pressed("ui_select"):
		audio_menu_select()
		var stat_description
		match description_index:
			0: stat_description = PlayerStats.vitality_description
			1: stat_description = PlayerStats.endurance_description
			2: stat_description = PlayerStats.defense_description
			3: stat_description = PlayerStats.strength_description
			4: stat_description = PlayerStats.dexterity_description
			5: stat_description = PlayerStats.speed_description
			6: stat_description = PlayerStats.magic_description
		var dialogBox = DialogBox.instance()
		dialogBox.dialog_script = [
			{
				"text": stat_description
			}
		]
		get_node("/root/World/GUI").add_child(dialogBox)

func _on_ButtonAlchemy_focus_entered():
	$StatsDisplay.hide()
	$PouchDisplay.hide()
	$AlchemyDisplay.hide()
	audio_menu_move()

func _on_ButtonAlchemy_pressed():
	audio_menu_select()
	$AlchemyDisplay.show()
	if $AlchemyDisplay/VBoxButtons.get_child_count() < 1:
		return
	else:
		$AlchemyDisplay/VBoxButtons.get_child(0).grab_focus()

func _on_ButtonAlchemy_focus_exited():
	pass

func _on_ButtonPouch_focus_entered():
	$AlchemyDisplay.hide()
	$ControlsDisplay.hide()
	$PouchDisplay.hide()
	audio_menu_move()

func _on_ButtonPouch_pressed():
	audio_menu_select()
	$PouchDisplay.show()
	if $PouchDisplay/VBox.get_child_count() < 1:
		return
	else:
		$PouchDisplay/VBox.get_child(0).get_child(0).grab_focus()

func _on_ButtonPouch_focus_exited():
	pass

func _on_ButtonControls_focus_entered():
	$PouchDisplay.hide()
	$StatsDisplay.hide()
	$ControlsDisplay.hide()
	audio_menu_move()

func _on_ButtonControls_pressed():
	audio_menu_select()
	$ControlsDisplay.show()

func _on_ButtonControls_focus_exited():
	pass
	
func audio_menu_move():
	$AudioMenu.stream = AudioMove
	$AudioMenu.play()
	
func audio_menu_select():
	$AudioMenu.stream = AudioSelect
	$AudioMenu.play()

func _on_ButtonInventory_focus_entered():
	return
# warning-ignore:unreachable_code
	$InventoryDisplay.show()
	audio_menu_move()

func _on_ButtonInventory_focus_exited():
	return
# warning-ignore:unreachable_code
	$InventoryDisplay.hide()
