extends Node2D

var above_z = 2
var middle_z = 0
var below_z = -2

func _on_MiddleTransition_body_entered(body):
	if body.z_index == middle_z:
		return
	Global.change_floor(body, middle_z)

func _on_BelowTransition_body_entered(body):
	if body.z_index == below_z:
		return
	Global.change_floor(body, below_z)

func _on_FlyZone_area_entered(area):
	if area.z_index == 0:
		area.z_index = -2

func _on_FlyZone_body_entered(body):
	if !body.flying && body.z_index == 0:
		print(body.name, ' landed in flyzone. lowering altitude')
		body.z_index = -2
		Enemy.set_player_collision(body)

func _on_FlyerArea_body_exited(body):
	print(body.name, ' left flyzone or took off. raising altitude')
	body.z_index = 0
	body.set_collision_mask_bit(17, false)
	Enemy.set_player_collision(body)
