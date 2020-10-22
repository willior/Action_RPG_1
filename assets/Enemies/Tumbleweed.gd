extends KinematicBody2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/Dialog.tscn")
const HeartPickup = preload("res://assets/Items/HeartPickup.tscn")
const PennyPickup = preload("res://assets/Items/PennyPickup.tscn")

export var ACCELERATION = 400
export var MAX_SPEED = 160
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
onready var sprite = $AnimatedSprite
onready var tween = $Tween
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var talkBox = $BatTalkBox/CollisionShape2D
onready var audio = $AudioStreamPlayer
onready var player = get_parent().get_parent().get_node("Player")

func _ready():
	add_to_group("enemies")
	sprite.playing = true

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) # knockback friction
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				
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
