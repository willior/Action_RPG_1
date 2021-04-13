extends Node2D
# collision mask bits // z_index:
# 11 below // -2
# 12 middle // 0
# 13 above // 2
var destination_z
var target_collision

func _on_UpperTransition_body_entered(body):
	destination_z = 0
	target_collision = 12
	Global.change_floor(body, destination_z, target_collision)

func _on_LowerTransition_body_entered(body):
	destination_z = -2
	target_collision = 11
	Global.change_floor(body, destination_z, target_collision)

func _on_FlyZone_area_entered(area):
	if area.z_index == 0:
		area.z_index = -2

func _on_FlyZone_body_entered(body):
	print('fly zone entered: ', body)
	if !body.flying && body.z_index == 0:
		print('lowering altitude')
		# body.z_index = -2

func _on_FlyZone_body_exited(body):
	print('fly zone exited: ', body)
	if body.flying && body.z_index == -2:
		print('raising altitude')
		# body.z_index = 0
