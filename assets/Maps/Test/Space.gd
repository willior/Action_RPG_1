extends Node2D

var player_spawn_pos = Vector2(320,580)

func zone_out():
	get_node("/root/World/").fade_out()

func _on_Timer_timeout():
	get_node("/root/World/").fade_out()
	var facing_direction = GameManager.player.dir_vector
	var new_inventory = [GameManager.player.pouch, GameManager.player.formulabook]
	if GameManager.multiplayer_2:
		var new_inventory_2 = GameManager.player2_data
		Global.goto_scene("res://assets/Maps/Test/LayerTest.tscn", {"direction": facing_direction, "location":Vector2(448,96), "inventory":new_inventory, "inventory_2":new_inventory_2})
		return
	else:
		Global.goto_scene("res://assets/Maps/Test/LayerTest.tscn", {"direction": facing_direction, "location":Vector2(448,96), "inventory":new_inventory})
