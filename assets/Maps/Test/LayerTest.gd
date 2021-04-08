extends Node2D

func _on_UpperTransition_body_entered(body):
	print("going up")
	body.z_index = 3
	body.set_collision_mask_bit(14, true)
	body.set_collision_mask_bit(15, false)

func _on_LowerTransition_body_entered(body):
	print("going down")
	body.z_index = 1
	body.set_collision_mask_bit(15, true)
	body.set_collision_mask_bit(14, false)

func _on_FlyingZ1_body_entered(body):
	body.z_index = 1

func _on_FlyingZ1_body_exited(body):
	body.z_index = 3
