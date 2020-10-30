extends Node
# GameManager initializes the player by getting a reference to them,
# then it emits a "player_initialized" signal to be listened for by the UI;
# this signal will connect the UI to the player inventory;
# meaning any changes reflected in the inventory will be reflected in the UI;
# when the program is first run, it attempts to load the inventory resource from a file;
# if it can't, it gives the player 2 potions instead;
# when the player is reinitialized, the old inventory is stored,
# and used as the argument to run the "reinitialize_player" function,
# which sets the current player scene's inventory to that of the argument's.

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
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	if not player:
		return

	emit_signal("player_reinitialized", player) 
	player.inventory.set_items(inventory.get_items())
	
func initialize_player():
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
		
# warning-ignore:unused_argument
func _on_player_inventory_changed(inventory):
# warning-ignore:return_value_discarded
	# ResourceSaver.save("user://inventory.tres", inventory)
	# prints(str(inventory) + str(OS.get_user_data_dir()))
	pass
