extends Node2D

onready var player
var hp_to_heal = 0
var heal_amount = 0
var heal_rate = 1
var total_healed = 0
var status = ["Regen", 1] # name, chance, duration, potency
var element = 9

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
	$CanvasLayer/ScreenTint.flash()

func heal():
	heal_amount = $FormulaHitbox.amount
	StatusHandler.apply_status(status, player)

func ability_end():
	$FormulaHitbox.set_deferred("monitorable", true)
	player.animationPlayer.play("Cast_2")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
