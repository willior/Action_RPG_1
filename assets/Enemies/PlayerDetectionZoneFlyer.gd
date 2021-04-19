extends Area2D

var player = null

onready var detectionZone = $CollisionShape2D

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	if body.z_index >= get_parent().z_index:
		player = body
		get_parent().z_index = player.z_index
	# detectionZone.scale *= 2

func _on_PlayerDetectionZone_body_exited(_body):
	player = null
	# detectionZone.scale /= 2
