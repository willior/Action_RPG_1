extends Formula
enum formulaSize {TINY, SMALL, MEDIUM, LARGE, HUGE}
export(formulaSize) var formula_size
onready var formula_shape = $FormulaHitbox/CollisionShape2D
var player
onready var formula_used = player.formulabook._formulas[player.formulabook.current_selected_formula]

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
	player.formulaData.apply_xp_to_formula(formula_used.formula_reference.name, player.name)
	queue_free()
