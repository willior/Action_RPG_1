extends TextureRect

#export onready var sprite = $Sprite
#export onready var label = $Label

func _init():
	# warning-ignore:return_value_discarded
	GameManager.connect("player_initialized", self, "_on_player_initialized")
# warning-ignore:return_value_discarded
	GameManager.connect("player_reinitialized", self, "_on_player_initialized")
	
func _on_player_initialized(player):
	player.formulabook.connect("current_selected_formula_changed", self, "_on_current_selected_formula_changed")

func _on_current_selected_formula_changed(new_selected_formula):
	print('current selected formula changed: ', new_selected_formula)
	for n in get_children():
		if !n.visible: n.visible = true
	$Icon.frames = new_selected_formula.formula_reference.icon
