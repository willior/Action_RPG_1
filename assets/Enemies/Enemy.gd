extends Node2D

# GENERIC ENEMY CLASS / REFACTOR PROJECT

# common elements of the bat & crow go into a generic enemy class.
# if their values need to be modified, export the appropriate variables.
# the “bat” & “crow” classes, after their shared code has been refactored,
# should extend this generic “enemy” class.

func set_player_collision(body):
	var player = get_node("/root/World/YSort/Player")
	if player.z_index == body.z_index:
		body.set_collision_layer_bit(4, true)
		body.disable_detection()
		body.enable_detection()
	else:
		body.set_collision_layer_bit(4, false)
