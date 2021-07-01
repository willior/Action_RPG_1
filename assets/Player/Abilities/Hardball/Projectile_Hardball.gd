extends KinematicBody2D

const ACCELERATION = 800
var target
var speed = 8
var velocity = Vector2.ZERO
var knockback_vector = Vector2.ZERO
var player

func _physics_process(delta):
	velocity = velocity.move_toward(knockback_vector*speed, delta*ACCELERATION) # multiplies that by the speed argument
	var collision = move_and_collide(velocity)
	if collision:
		print('collision detected. determining behaviour...')
		if collision.collider.has_method("_on_Hurtbox_area_entered"):
			collision.collider._on_Hurtbox_area_entered($FormulaHitbox)
		print('projectile collided with ', collision.collider.name, '; deleting projectile.')
		queue_free()
	if global_position.distance_to(target) <= 16:
		print('projectile reached target. deleting projectile.')
		queue_free()

#func accelerate_towards_point(point):
#	var knockback_vector = global_position.knockback_vector_to(point) # gets the knockback_vector by grabbing the target position, the point argument
#	velocity = velocity.move_toward(knockback_vector, speed) # multiplies that by the speed argument
#	if global_position.distance_to(target) <= 16:
#		print('projectile reached target. deleting projectile.')
#		queue_free()
