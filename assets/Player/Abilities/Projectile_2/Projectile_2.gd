extends KinematicBody2D

const ACCELERATION = 100
var target
var speed = 100
var velocity = Vector2.ZERO
var player

func _ready():
	print(target)

func _process(delta):
	accelerate_towards_point(target, delta)
# warning-ignore:return_value_discarded
	move_and_collide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
	velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument
	if global_position.distance_to(target) <= 40:
		queue_free()
