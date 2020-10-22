extends KinematicBody2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/Dialog.tscn")
const HeartPickup = preload("res://assets/Items/HeartPickup.tscn")
const PennyPickup = preload("res://assets/Items/PennyPickup.tscn")

export var ACCELERATION = 200
export var MAX_SPEED = 100
export var FRICTION = 240

enum {
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	DEAD
}
var state = IDLE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var interactable = false
var talkable = false
var examined = false
var facingLeft = false

onready var timer = $Timer
onready var sprite = $Sprite
onready var tween = $Tween
onready var hitbox = $Hitbox
onready var talkBox = $Talkbox/CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var audio = $AudioStreamPlayer
onready var player = get_parent().get_parent().get_node("Player")
onready var target_vector = Vector2(-1, 0)

func _ready():
	add_to_group("enemies")
	animationPlayer.play("Animate")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2(target_vector) * MAX_SPEED, ACCELERATION * delta)
				
		WANDER:
			pass
				
		CHASE:
			pass

		ATTACK:
			pass
			
		DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	sprite.flip_h = velocity.x < 0
	
	velocity = move_and_slide(velocity)

func examine():
	var dialogBox = DialogBox.instance()
	dialogBox.dialog = [
		"Unsatisfied with sedentary life, the tumbleweed breaks away form its roots and rides the wind.",
		"An example of functional death, its structure degrades gradually allowing seeds to be sewn."
	]
	get_node("/root/World/GUI").add_child(dialogBox)
	if !examined: examined = true
