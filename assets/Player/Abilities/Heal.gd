extends Node2D

onready var player = get_tree().get_root().get_node("/root/World/YSort/Player")

var heal_amount = 0
var heal_rate = 1
var total_healed = 0

func _ready():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	$AnimationPlayer.play("Ability")
	
func _process(_delta):
	if total_healed < heal_amount:
		total_healed += heal_rate
		player.stats.health += heal_rate
	else:
		return
		
func ability_start():
	$AudioStreamPlayer.play()

func heal():
	heal_amount = 30
	$CanvasLayer/Cyan.flash()

func ability_end():
	# $SpellHitbox.set_deferred("monitorable", true)
	player.animationPlayer.play("Cast_2")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
