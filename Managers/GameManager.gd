extends Node

signal player_initialized
signal player_reinitialized

var existing_inventory

var player
	
# warning-ignore:unused_argument
func _process(delta):
	if not player:
		initialize_player()
		return
		
func reinitialize_player(inventory):
	print('2. reinitializing player')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	
	# THIS SIGNAL DOES NOT GET HEARD:
	emit_signal("player_reinitialized", player) 
	#
	# player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	player.inventory.set_items(inventory.get_items())
	
func initialize_player():
	print('2. initializing player')
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	if not player:
		return
	
	emit_signal("player_initialized", player)
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	if !ResourceLoader.exists("user://inventory.tres"):
		player.inventory.add_item("Potion", 2)
	else:
		var loaded_inventory = load("user://inventory.tres")
		if loaded_inventory:
			player.inventory.set_items(loaded_inventory.get_items())
		
func _on_player_inventory_changed(inventory):
# warning-ignore:return_value_discarded
	# ResourceSaver.save("user://inventory.tres", inventory)
	prints(str(inventory) + str(OS.get_user_data_dir()))
