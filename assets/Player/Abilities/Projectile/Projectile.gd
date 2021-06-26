extends KinematicBody2D

var angle : float
var velocity = Vector2.ZERO

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		_on_impact(collision.normal)

func launch(direction):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp

func _on_impact(normal : Vector2):
	pass
