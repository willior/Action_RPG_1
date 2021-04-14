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

# warning-ignore:unused_argument
func _on_FlyZone_body_entered(body): pass
#	if body.flying && body.z_index == 0:
#		print('lowering altitude')
#		body.z_index = -2

# warning-ignore:unused_argument
func _on_FlyZone_body_exited(body): pass
#	if body.flying && body.z_index == -2:
#		print('raising altitude')
#		body.z_index = 0
