extends KinematicBody2D
var HitEffect = load("res://assets/Effects/Abilities/Hardball_HitEffect.tscn")
const ACCELERATION = 800
var target
var speed = 12
var velocity = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var player
var done = false

func _physics_process(delta):
	if done: return
	velocity = velocity.move_toward(knockback_vector*speed, delta*ACCELERATION) # multiplies that by the speed argument
	var collision = move_and_collide(velocity)
	if collision:
		if collision.collider.has_method("_on_Hurtbox_area_entered"):
			collision.collider._on_Hurtbox_area_entered($FormulaHitbox)
		collision()
	if global_position.distance_to(target) <= 16:
		collision()

#func accelerate_towards_point(point):
#	var knockback_vector = global_position.knockback_vector_to(point) # gets the knockback_vector by grabbing the target position, the point argument
#	velocity = velocity.move_toward(knockback_vector, speed) # multiplies that by the speed argument
#	if global_position.distance_to(target) <= 16:
#		print('projectile reached target. deleting projectile.')
#		queue_free()

func collision():
	done = true
	$Sprite.hide()
	$CollisionShape2D.set_deferred("disabled", true)
	var hit_effect = HitEffect.instance()
	hit_effect.position = position
	get_tree().get_root().get_node("World/YSort").add_child(hit_effect)

func _on_Trail_tree_exiting():
	queue_free()
