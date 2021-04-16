extends Node2D

onready var player = get_tree().get_root().get_node("/root/World/YSort/Player")

func _ready():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast")
	$AudioStreamPlayer.play()

func _on_Timer_timeout():
	$CanvasLayer/White.flash()
	$SpellHitbox.set_deferred("monitorable", true)
#	$Timer.start(0.1)
#	yield($Timer, "timeout")
#	$Timer.queue_free()
#	$SpellHitbox.set_deferred("monitorable", false)
#	print('hitbox gone')

func _on_AudioStreamPlayer_finished():
	print('spell deleted')
	queue_free()
