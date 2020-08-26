extends KinematicBody2D

const ACCELERATION = 1600
const MAX_SPEED = 100
const ROLL_SPEED = 200
const FRICTION = 3200

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var roll_moving = false

onready var animationPlayer = $AnimationPlayer # declaring animationPlayer to give access to the AnimationPlayer node
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	animationTree.active = true # animation not active until game starts
	swordHitbox.knockback_vector = roll_vector

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)

func move_state(delta):
	# if player is not moving
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength ("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# if player is moving
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("roll"):
		roll_moving = true
		state = ROLL
		
func move():
	velocity = move_and_slide(velocity)

# warning-ignore:unused_argument
func attack_state(delta):
	animationState.travel("Attack")
	
func attack_animation_finished():
	state = MOVE

# warning-ignore:unused_argument
func roll_state(delta):
	if roll_moving:
		velocity = roll_vector * ROLL_SPEED
	else:
		velocity = roll_vector * (ROLL_SPEED/4)
	
	animationState.travel("Roll")
	move()
	
func roll_stop():
	roll_moving = false
	
func roll_animation_finished():
	state = MOVE
