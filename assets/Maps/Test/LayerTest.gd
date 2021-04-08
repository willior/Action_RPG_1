extends Node2D
# collision mask bits // z_index:
# 13 bottom // 1
# 14 lower // 3
# 15 upper // 5
# 16 top // 7
var destination_z
var target_collision
var other_collisions

func _on_UpperTransition_body_entered(body):
	destination_z = 5
	target_collision = 15
	Global.change_floor(body, destination_z, target_collision)

func _on_LowerTransition_body_entered(body):
	destination_z = 3
	target_collision = 14
	Global.change_floor(body, destination_z, target_collision)

func _on_FlyingZ1_body_entered(body):
	body.z_index = 1

func _on_FlyingZ1_body_exited(body):
	body.z_index = 3
