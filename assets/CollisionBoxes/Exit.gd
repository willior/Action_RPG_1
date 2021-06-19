extends Area2D
# Exit scene
# the shape CollisionShape2D must be shared by the StaticBody2D child and the Exit area node itself.
# StaticBody2D World collision gets enabled on Player dying, preventing zoning while dying.
export(String, FILE) var map_file
export var selected_location = Vector2()
var facing_direction = Vector2()

#func _ready():
## warning-ignore:return_value_discarded
#	Player1Stats.connect("player_dying", self, "disable_exit")
## warning-ignore:return_value_discarded
#	Player1Stats.connect("player_leveling", self, "disable_exit")
## warning-ignore:return_value_discarded
#	Player2Stats.connect("player_dying", self, "disable_exit")
## warning-ignore:return_value_discarded
#	Player2Stats.connect("player_leveling", self, "disable_exit")

func _on_Exit_body_entered(body):
	facing_direction = body.dir_vector
	get_node("/root/World/").fade_out()
	$Timer.start()
	yield($Timer, "timeout")
	var new_inventory = [GameManager.player.pouch, GameManager.player.formulabook]
	
	if GameManager.multiplayer_2:
		var new_inventory_2 = GameManager.player2_data
		Global.goto_scene(map_file, {"direction": facing_direction, "location":selected_location, "inventory":new_inventory, "inventory_2":new_inventory_2})
		return
	else:
		Global.goto_scene(map_file, {"direction": facing_direction, "location":selected_location, "inventory":new_inventory})

func exit_collision(value):
	$StaticBody2D.set_collision_layer_bit(0, value)
