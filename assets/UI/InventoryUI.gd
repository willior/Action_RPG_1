extends TextureRect

#export onready var sprite = $Sprite
#export onready var label = $Label

func _init():
	# warning-ignore:return_value_discarded
	GameManager.connect("player_initialized", self, "_on_player_initialized")
# warning-ignore:return_value_discarded
	GameManager.connect("player_reinitialized", self, "_on_player_initialized")
	
func _on_player_initialized(player):
	player.inventory.connect("selected_item_quantity_updated", self, "_on_selected_item_quantity_updated")
	player.inventory.connect("current_selected_item_changed", self, "_on_current_selected_item_changed")
	player.inventory.connect("item_quantity_zero", self, "_on_item_quantity_zero")

func _on_selected_item_quantity_updated(updated_selected_item):
	for n in get_children():
		if !n.visible: n.visible = true
		
#	var label = Label.new()
	# label.text = "%s x%d" % [updated_selected_item.item_reference.name, updated_selected_item.quantity]
	$Label.text = "%d" % [updated_selected_item.quantity]
#	add_child(label)
#	var sprite = Sprite.new()
	$Sprite.texture = updated_selected_item.item_reference.texture
#	add_child(sprite)

func _on_current_selected_item_changed(new_selected_item):
	for n in get_children():
		if !n.visible: n.visible = true
		
#	var label = Label.new()
	# label.text = "%s x%d" % [new_selected_item.item_reference.name, new_selected_item.quantity]
	$Label.text = "%d" % [new_selected_item.quantity]
#	add_child(label)
#	var sprite = Sprite.new()
	$Sprite.texture = new_selected_item.item_reference.texture
#	add_child(sprite)
	
func _on_item_quantity_zero():
	for n in get_children():
		n.visible = false
	print('item zero')
