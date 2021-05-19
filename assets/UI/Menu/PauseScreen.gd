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
onready var GUI = get_tree().get_root().get_node("World/GUI")
var closing = false
var moving = false
var player
var up
var down
var left
var right
var accept
var cancel
var start
func _ready():
	up = "ui_up"
	down = "ui_down"
	left = "ui_left"
	right = "ui_right"
	accept = "ui_accept"
	cancel = "ui_cancel"
	if player.name == "Player2":
		start = "start_2"
	else:
		start = "start"
#		"Player2":
#			up = "ui_up_2"
#			down = "ui_down_2"
#			left = "ui_left_2"
#			right = "ui_right_2"
#			accept = "ui_accept_2"
#			cancel = "ui_cancel_2"
#			start = "start_2"
	$Tween.interpolate_property($CanvasLayer/PanelTop, "rect_position",
	Vector2(0, -45),
	Vector2(0, 0),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	$Tween.interpolate_property($CanvasLayer/PanelBottom, "rect_position",
	Vector2(0, 270),
	Vector2(0, 225),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	$Tween.interpolate_property($CanvasLayer/ColorRect, "color",
	Color(0,0,0,0),
	Color(0,0,0,0.5),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_OUT
	)
	$Tween.interpolate_property($MenuPanel, "rect_position",
	Vector2(-220, 60),
	Vector2(130, 60),
	0.4,
	Tween.TRANS_QUART, Tween.EASE_OUT
	)
	$Tween.start()
	healthBox.set_text(str(player.stats.vitality)) # + " (" + str(player.stats.health) + "/" + str(player.stats.max_health) + "HP)")
	enduranceBox.set_text(str(player.stats.endurance))
	defenseBox.set_text(str(player.stats.defense))
	strengthBox.set_text(str(player.stats.strength))
	dexterityBox.set_text(str(player.stats.dexterity))
	speedBox.set_text(str(player.stats.speed))
	magicBox.set_text(str(player.stats.magic))
	vitBar.value = player.stats.vitality
	endBar.value = player.stats.endurance
	defBar.value = player.stats.defense
	strBar.value = player.stats.strength
	dexBar.value = player.stats.dexterity
	spdBar.value = player.stats.speed
	magBar.value = player.stats.magic
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

func disable_menu_focus():
	for b in $MenuPanel/Menu.get_children().size():
		$MenuPanel/Menu.get_child(b).set_focus_mode(0)
		
func enable_menu_focus():
	for b in $MenuPanel/Menu.get_children().size():
		$MenuPanel/Menu.get_child(b).set_focus_mode(2)

func _input(event):
	match player.name:
		"Player":
			match event.as_text():
				"I":
					get_tree().set_input_as_handled()
					return
				"J":
					get_tree().set_input_as_handled()
					return
				"K":
					get_tree().set_input_as_handled()
					return
				"L":
					get_tree().set_input_as_handled()
					return
				"Slash":
					get_tree().set_input_as_handled()
					return
				"Shift":
					get_tree().set_input_as_handled()
					return
				"Semicolon":
					get_tree().set_input_as_handled()
					return
				"Enter":
					get_tree().set_input_as_handled()
					return
		"Player2":
			match event.as_text():
				"W":
					get_tree().set_input_as_handled()
					return
				"S": 
					get_tree().set_input_as_handled()
					return
				"A": 
					get_tree().set_input_as_handled()
					return
				"D": 
					get_tree().set_input_as_handled()
					return
				"V": 
					get_tree().set_input_as_handled()
					return
				"B": 
					get_tree().set_input_as_handled()
					return
				"F": 
					get_tree().set_input_as_handled()
					return
				"Space":
					get_tree().set_input_as_handled()
					return

func _on_PauseScreen_gui_input(event):
	get_tree().set_input_as_handled()
	if closing or moving:
		return
	elif event.is_action_pressed(cancel) or event.is_action_pressed(start):
		hide_status_display()
		close_pause_menu()

func close_pause_menu():
	for b in $MenuPanel/Menu.get_children().size():
		$MenuPanel/Menu.get_child(b).set_focus_mode(0)
	closing = true
	$Tween.interpolate_property($MenuPanel, "rect_position",
	Vector2(128, 60),
	Vector2(480, 60),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_IN
	)
	$Tween.interpolate_property($CanvasLayer/PanelTop, "rect_position",
	Vector2(0, 0),
	Vector2(0, -45),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_IN
	)
	$Tween.interpolate_property($CanvasLayer/PanelBottom, "rect_position",
	Vector2(0, 225),
	Vector2(0, 270),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_IN
	)
	$Tween.interpolate_property($CanvasLayer/ColorRect, "color",
	Color(0,0,0,0.5),
	Color(0,0,0,0),
	0.4,
	Tween.TRANS_QUINT, Tween.EASE_IN
	)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	get_tree().get_root().get_node("World").close_pause_menu()

func _on_ButtonStatus_focus_entered():
	$MenuPanel/Menu/ButtonStatus.pressed = false
	audio_menu_move()

func _on_ButtonStatus_pressed():
	audio_menu_select()
	disable_menu_focus()
	$Tween.interpolate_property($StatsDisplay, "rect_size", Vector2(220, 0), Vector2(220, 130), 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$StatsDisplay.show()
	yield($Tween, "tween_all_completed")
	$StatsDisplay/VBoxButtons/ButtonVIT.grab_focus()
	audio_menu_move()

func _on_ButtonStatus_focus_exited():
	pass

func _on_ButtonSTAT_gui_input(event, description_index):
	if event.is_action_pressed(up) or event.is_action_pressed(down):
		audio_menu_move()
	elif event.is_action_pressed(cancel):
		hide_status_display()
		enable_menu_focus()
		$MenuPanel/Menu/ButtonStatus.grab_focus()
	elif event.is_action_pressed(accept):
		audio_menu_select()
		var stat_description
		match description_index:
			0: stat_description = player.stats.vitality_description
			1: stat_description = player.stats.endurance_description
			2: stat_description = player.stats.defense_description
			3: stat_description = player.stats.strength_description
			4: stat_description = player.stats.dexterity_description
			5: stat_description = player.stats.speed_description
			6: stat_description = player.stats.magic_description
		var dialogBox = DialogBox.instance()
		dialogBox.dialog_script = [
			{
				"text": stat_description
			}
		]
		get_node("/root/World/GUI").add_child(dialogBox)
	elif event.is_action_pressed(start):
		hide_status_display()
		close_pause_menu()

func _on_ButtonAlchemy_focus_entered():
	$MenuPanel/Menu/ButtonAlchemy.pressed = false
	audio_menu_move()

func _on_ButtonAlchemy_pressed():
	audio_menu_select()
	$Tween.interpolate_property($AlchemyDisplay, "rect_size", Vector2(220, 0), Vector2(220, 130), 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$AlchemyDisplay.show()
	disable_menu_focus()
	yield($Tween, "tween_all_completed")
	if $AlchemyDisplay/VBoxButtons.get_child_count() < 1:
		return
	else:
		$AlchemyDisplay/VBoxButtons.get_child(0).grab_focus()
		audio_menu_move()

func _on_ButtonAlchemy_focus_exited():
	pass

func _on_ButtonPouch_focus_entered():
	$MenuPanel/Menu/ButtonPouch.pressed = false
	audio_menu_move()

func _on_ButtonPouch_pressed():
	audio_menu_select()
	$Tween.interpolate_property($PouchDisplay, "rect_size", Vector2(220, 0), Vector2(220, 130), 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$PouchDisplay.show()
	disable_menu_focus()
	yield($Tween, "tween_all_completed")
	if $PouchDisplay/VBox.get_child_count() < 1:
		return
	else:
		$PouchDisplay/VBox.get_child(0).get_child(0).grab_focus()
		audio_menu_move()

func _on_ButtonPouch_focus_exited():
	pass

func _on_ButtonConfig_focus_entered():
	$MenuPanel/Menu/ButtonConfig.pressed = false
	audio_menu_move()

func _on_ButtonConfig_pressed():
	audio_menu_select()
	disable_menu_focus()
	$Tween.interpolate_property($ConfigDisplay, "rect_size", Vector2(220, 0), Vector2(220, 130), 0.4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	$Tween.start()
	$ConfigDisplay.show()
	yield($Tween, "tween_all_completed")
	$ConfigDisplay/VBox/ButtonControls.grab_focus()
	audio_menu_move()

func _on_ButtonConfig_focus_exited():
	pass

func _on_ButtonControls_gui_input(event):
	if event.is_action_pressed(accept) and !$CanvasLayer1/ControlsDisplay.visible:
		$CanvasLayer1/ControlsDisplay.show()
		$Tween.interpolate_property($CanvasLayer1/ControlsDisplay, "rect_position", Vector2(-480, 0), Vector2(0, 0), 0.4, Tween.TRANS_QUINT, Tween.EASE_OUT)
		$Tween.start()
		moving = true
		yield($Tween, "tween_all_completed")
		moving = false
	elif (event.is_action_pressed(cancel) or event.is_action_pressed(accept)) and $CanvasLayer1/ControlsDisplay.visible and !moving:
		$Tween.interpolate_property($CanvasLayer1/ControlsDisplay, "rect_position", Vector2(0, 0), Vector2(480, 0), 0.4, Tween.TRANS_QUINT, Tween.EASE_IN)
		$Tween.start()
		moving = true
		yield($Tween, "tween_all_completed")
		moving = false
		$CanvasLayer1/ControlsDisplay.hide()
	elif event.is_action_pressed(cancel):
		hide_config_display()
		enable_menu_focus()
		$MenuPanel/Menu/ButtonConfig.grab_focus()
	elif event.is_action_pressed(start):
		if $CanvasLayer1/ControlsDisplay.visible and !moving:
			$Tween.interpolate_property($CanvasLayer1/ControlsDisplay, "rect_position", Vector2(0, 0), Vector2(480, 0), 0.4, Tween.TRANS_QUINT, Tween.EASE_IN)
			$Tween.start()
			hide_config_display()
			close_pause_menu()
		elif !$CanvasLayer1/ControlsDisplay.visible:
			hide_config_display()
			close_pause_menu()

func _on_ButtonSave_gui_input(event):
	if event.is_action_pressed(accept):
		GameManager.save_game()
	elif event.is_action_pressed(cancel):
		hide_config_display()
		enable_menu_focus()
		$MenuPanel/Menu/ButtonConfig.grab_focus()
	elif event.is_action_pressed(start):
		hide_config_display()
		close_pause_menu()

func _on_ButtonLoad_gui_input(event):
	if event.is_action_pressed(accept):
		get_tree().paused = false
		Global.goto_scene("res://assets/System/MainMenu.tscn")
	elif event.is_action_pressed(cancel):
		hide_config_display()
		enable_menu_focus()
		$MenuPanel/Menu/ButtonConfig.grab_focus()
	elif event.is_action_pressed(start):
		hide_config_display()
		close_pause_menu()

func audio_menu_move():
	$AudioMenu.stream = AudioMove
	$AudioMenu.play()

func audio_menu_select():
	$AudioMenu.stream = AudioSelect
	$AudioMenu.play()

func hide_status_display():
	$Tween.interpolate_property($StatsDisplay, "rect_size", Vector2(220, 130), Vector2(220, 0), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$StatsDisplay.hide()

func hide_alchemy_display():
	$Tween.interpolate_property($AlchemyDisplay, "rect_size", Vector2(220, 130), Vector2(220, 0), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$AlchemyDisplay.hide()

func hide_pouch_display():
	$Tween.interpolate_property($PouchDisplay, "rect_size", Vector2(220, 130), Vector2(220, 0), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$PouchDisplay.hide()
	
func hide_config_display():
	$Tween.interpolate_property($ConfigDisplay, "rect_size", Vector2(220, 130), Vector2(220, 0), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$ConfigDisplay.hide()

func _on_ButtonInventory_focus_entered(): pass
#	return
#	$InventoryDisplay.show()
#	audio_menu_move()

func _on_ButtonInventory_focus_exited(): pass
#	return
#	$InventoryDisplay.hide()
