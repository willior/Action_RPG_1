extends Area2D

var player = null

onready var attackZone = $CollisionShape2D
onready var attackTimer = $AttackTimer

func can_attack_player():
	return player != null

func _on_AttackPlayerZone_body_entered(body):
	player = body

# warning-ignore:unused_argument
func _on_AttackPlayerZone_body_exited(body):
	player = null
