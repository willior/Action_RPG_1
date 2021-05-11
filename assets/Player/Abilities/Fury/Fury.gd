extends Node2D

onready var player = get_tree().get_root().get_node("/root/World/YSort/Player")

var status = ["Frenzy", 1.0] # "Name", application chance, duration, potency
# var duration = 3

func _ready():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	$AnimationPlayer.play("Ability")

func ability_start():
	$AudioStreamPlayer.play()
	$CanvasLayer/ScreenTint.flash()

func cast():
	StatusHandler.apply_status(status, player)
	print(status)

func ability_end():
	$FormulaHitbox.set_deferred("monitorable", true)
	player.animationPlayer.play("Cast_2")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
