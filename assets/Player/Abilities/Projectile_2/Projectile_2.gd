extends KinematicBody2D

const ACCELERATION = 160
var direction
var target
var speed = 16
var velocity = Vector2.ZERO
var player

func _ready():
	print('projectile target pos: ', target)
	direction = global_position.direction_to(target) # gets the direction by grabbing the target position
	# velocity = velocity.move_toward(direction, speed) # multiplies that by the speed argument

func _process(delta):
	velocity = velocity.move_toward(direction*speed, delta*ACCELERATION)
	if move_and_collide(velocity) != null:
		print('projectile collided with something: ', move_and_collide(velocity), '; deleting projectile.')
		queue_free()
	if global_position.distance_to(target) <= 16:
		print('projectile reached target. deleting projectile.')
		queue_free()

#func accelerate_towards_point(point):
#	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
#	velocity = velocity.move_toward(direction, speed) # multiplies that by the speed argument
#	if global_position.distance_to(target) <= 16:
#		print('projectile reached target. deleting projectile.')
#		queue_free()
