extends Area2D

var player = null

onready var atackZone = $CollisionShape2D

func can_attack_player():
	return player != null

func _on_AttackPlayerZone_body_entered(body):
	player = body
	print("player in attack zone")

func _on_AttackPlayerZone_body_exited(body):
	player = null
	print("player out of attack zone")
