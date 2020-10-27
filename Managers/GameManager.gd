extends Node

signal player_initialized

var player

func _process(delta):
	if not player:
		initialize_player()
		return
		
func initialize_player():
	player = get_tree().get_root().get_node("/root/World/YSort/Player")
	if not player:
		return
	
	emit_signal("player_initialized", player)
	
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
	var existing_inventory = load("user://inventory.tres")
	if existing_inventory:
		player.inventory.set_items(existing_inventory.get_items())
	else:
		player.inventory.add_item("Potion", 2)
	
func _on_player_inventory_changed(inventory):
	ResourceSaver.save("user://inventory.tres", inventory)
