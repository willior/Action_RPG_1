extends KinematicBody2D
const ENEMY_NAME = "Tumbleweed"
const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")

export var ACCELERATION = 1600
export var MAX_SPEED = 96
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
var x_velocity
var y_velocity
var speed_mod = 0

onready var timer = $Timer
onready var sprite = $Sprite
onready var tween = $Tween
onready var hitbox = $Hitbox
onready var talkBox = $Talkbox/CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var audio = $AudioStreamPlayer
onready var player = get_parent().get_parent().get_node("Player")
onready var map = get_parent().get_parent().get_parent().get_node("Map")

# Y axis speed will vary within a small range
# spawns on player's x.position + 320 or, exactly 1 screen to the right
# spawns on player's y.position randi_range(-90,90)

func _ready():
# warning-ignore:return_value_discarded
	PlayerLog.connect("Tumbleweed_complete", self, "examine_complete")
	if ENEMY_NAME in PlayerLog.examined_list:
		examined = true
	add_to_group("enemies")
	animationPlayer.play("Animate")
	speed_mod = rand_range(0,32)
	x_velocity = MAX_SPEED + speed_mod
	if map.wind_direction == "left":
		x_velocity = -MAX_SPEED - speed_mod
	elif map.wind_direction == "right":
		x_velocity = MAX_SPEED + speed_mod
	if player.velocity.y != 0:
		y_velocity = clamp(rand_range(player.velocity.y/8, player.velocity.y), -80, 80)
		# prints("player moving; tumbleweed y_velocity = " + str(y_velocity))
	else:
		y_velocity = rand_range(-16,16)
		# prints("randomizing tumbleweed y_velocity: " + str(y_velocity))

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2(x_velocity, y_velocity), ACCELERATION * delta)
				
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
	var dialog_script = [
		{'text': "Unsatisfied with sedentary life, the tumbleweed breaks away form its roots and rides the wind."},
		{'text': "Its structure degrades gradually, allowing seeds to be sewn. An example of functional death."}
	]
	Enemy.examine(dialog_script, examined, ENEMY_NAME)

func examine_complete(value):
	examined = value

func play_sound():
	var sound_choice = randi() % 3
	match sound_choice:
		0:
			$AudioStreamPlayer.stream = load("res://assets/Audio/Enemies/Tumbleweed_Sound_1.wav")
		1:
			$AudioStreamPlayer.stream = load("res://assets/Audio/Enemies/Tumbleweed_Sound_2.wav")
		2:
			$AudioStreamPlayer.stream = load("res://assets/Audio/Enemies/Tumbleweed_Sound_3.wav")
			
	$AudioStreamPlayer.play()
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
