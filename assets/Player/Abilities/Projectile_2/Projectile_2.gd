extends KinematicBody2D

const ACCELERATION = 100
var dir_vector
var velocity = 4

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func accelerate_towards_point(point, speed, delta):
	var direction = global_position.direction_to(point) # gets the direction by grabbing the target position, the point argument
	velocity = velocity.move_toward(direction * speed, ACCELERATION * delta) # multiplies that by the speed argument
