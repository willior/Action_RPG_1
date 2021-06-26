extends Node2D
enum formulaSize {TINY, SMALL, MEDIUM, LARGE, HUGE}
export(formulaSize) var formula_size
onready var formula_shape = $FormulaHitbox/CollisionShape2D
var player

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
	pass

func ability_end():
	pass
