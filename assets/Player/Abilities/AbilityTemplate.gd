extends Node2D

onready var player = get_tree().get_root().get_node("/root/World/YSort/Player")

func _ready():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	yield(get_tree().create_timer(0.35), "timeout")
	
	$AudioStreamPlayer.play()
	get_node("/root/World/Camera2D").decay = 0
	get_node("/root/World/Camera2D").add_trauma(0.05)
	$Timer.start()
	yield($Timer, "timeout")
	
	get_node("/root/World/Camera2D").add_trauma(0.1)
	$Timer.start()
	yield($Timer, "timeout")
	
	get_node("/root/World/Camera2D").add_trauma(0.2)
	$Timer.start()
	yield($Timer, "timeout")
	
	get_node("/root/World/Camera2D").stop_shake()
	get_node("/root/World/Camera2D").decay = 1
	$CanvasLayer/White.flash()
	$SpellHitbox.set_deferred("monitorable", true)
	player.animationPlayer.play("Cast_2")
	$Timer.start()
	yield($Timer, "timeout")
	queue_free()
