extends Node2D
enum formulaSize {TINY, SMALL, MEDIUM, LARGE, HUGE, SCREEN}
export(formulaSize) var formula_size
onready var formula_shape = $FormulaHitbox/CollisionShape2D
var player
var status = ["Frenzy", 1.0] # "Name", application chance, duration, potency

func _ready():
	$FormulaTargetScreen.target_size = formula_size
	match formula_size:
		0:
			formula_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_8.tres")
		1:
			formula_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_16.tres")
		2:
			formula_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_32.tres")
		3:
			formula_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_64.tres")
		4:
			formula_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_128.tres")
		5:
			pass

func start():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	$AnimationPlayer.play("Ability")

func ability_start():
	$AudioStreamPlayer.play()
	$CanvasLayer/ScreenTint.flash()

func ability_end():
	$FormulaHitbox.set_deferred("monitorable", true)
	player.animationPlayer.play("Cast_2")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
