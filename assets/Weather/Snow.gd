extends Node2D

onready var player = get_tree().get_root().get_node("World/YSort/Player")
var default = 1

func _process(delta):
	# $Particle2D.process_material.set_shader_param("gravity", (Vector3(0, -player.velocity.y, 0)))
	if player.velocity.y < 0:
		$Particle2D.speed_scale = default
		$Particle2D.speed_scale = 1.5
	elif player.velocity.y > 0:
		$Particle2D.speed_scale = default
		$Particle2D.speed_scale = 0.75
	else:
		print("defaulting")
		$Particle2D.speed_scale = default
