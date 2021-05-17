extends Node2D
onready var player

func start():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	$AnimationPlayer.play("Ability")

func ability_1():
	$AudioStreamPlayer.play()
	get_node("/root/World/Camera2D").decay = 0
	get_node("/root/World/Camera2D").add_trauma(0.05)

func ability_2():
	get_node("/root/World/Camera2D").add_trauma(0.1)

func ability_3():
	get_node("/root/World/Camera2D").add_trauma(0.2)

func ability_4():
	get_node("/root/World/Camera2D").stop_shake()
	get_node("/root/World/Camera2D").decay = 1
	$CanvasLayer/White.flash()
	sprite_flash()
	$FormulaHitbox.set_deferred("monitorable", true)
	player.animationPlayer.play("Cast_2")

func sprite_flash():
	$FormulaHitbox/Sprite.show()
	$Tween.interpolate_property(
		$FormulaHitbox/Sprite,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		0.1,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT
	)
	$Tween.start()

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
