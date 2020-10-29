extends GridContainer

func _init():
	# warning-ignore:return_value_discarded
	GameManager.connect("player_initialized", self, "_on_player_initialized")
# warning-ignore:return_value_discarded
	GameManager.connect("player_reinitialized", self, "_on_player_initialized")
	
func _on_player_initialized(player):
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
func _on_player_inventory_changed(inventory):
	for n in get_children():
		n.queue_free()
	for item in inventory.get_items():
		var item_label = Label.new()

		item_label.text = "%s x%d" % [item.item_reference.name, item.quantity]
		add_child(item_label)
