extends Node2D
var Projectile = load("res://assets/Player/Abilities/Hardball/Projectile_Hardball.tscn")
# var Trail = load("res://assets/Effects/Trail.tscn")
#enum formulaSize {TINY, SMALL, MEDIUM, LARGE, HUGE}
#export(formulaSize) var formula_size
#onready var formula_shape = $FormulaHitbox/CollisionShape2D
var player
var knockback

#func _ready():
#	$FormulaTargetScreen.target_size = formula_size

func start():
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	$AnimationPlayer.play("Ability")

func ability_start():
	var projectile = Projectile.instance()
	projectile.player = player
	projectile.position = position
	projectile.target = $FormulaHitbox/RayCast2D.to_global($FormulaHitbox/RayCast2D.get_cast_to())
	projectile.knockback_vector = global_position.direction_to(projectile.target)
	get_tree().get_root().get_node("World/YSort").add_child(projectile)
#	var trail = Trail.instance()
#	trail.target = projectile
#	get_tree().get_root().get_node("World/YSort").add_child(trail)
#	if $FormulaHitbox/RayCast2D.is_colliding():
#		if $FormulaHitbox/RayCast2D.get_collider().name == "Hurtbox":
#			print('Hardball hit a hurtbox: ', $FormulaHitbox/RayCast2D.get_collider().get_parent().name)
#			$FormulaHitbox/RayCast2D.get_collider().get_parent()._on_Hurtbox_area_entered($FormulaHitbox)
#		else:
#			print('Hardball collision with non-enemy: ', $FormulaHitbox/RayCast2D.get_collider().name)
#		return
#	print('Hardball missed: showing trajectory in purple')
#	$FormulaHitbox/Sprite.show()

func ability_end():
	player.animationPlayer.play("Cast_2")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
