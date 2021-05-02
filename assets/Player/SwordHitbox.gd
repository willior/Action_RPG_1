extends Area2D

onready var sword_attack = preload("res://assets/Audio/Player/Sword_Attack_1.wav")
onready var flash_whoosh = preload("res://assets/Audio/Player/Sword_Flash_Whoosh.wav")
onready var flash_swing = preload("res://assets/Audio/Player/Sword_Flash_Swing.wav")
onready var audio = $AudioStreamPlayer

# onready var damage_mod = PlayerStats.strength_mod setget set_damage_mod
# onready var shade_mod = PlayerStats.strength_mod setget set_shade_mod
var base_damage = 4
onready var damage # setget set_damage
var orig_damage
var randomness = 0.16
var knockback_vector = Vector2.ZERO

var formula = false

func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_changed", self, "set_damage")
	damage = base_damage + PlayerStats.strength
	orig_damage = damage
	# print('damage = ', damage)

func set_damage(value):
	damage = base_damage + value
	orig_damage = damage
	print('STR increased. new damage set = ', damage)

func modify_damage(base, modulator):
	return int(base * modulator)

func reset_damage():
	damage = orig_damage
	$CollisionShape2D.scale.x = 1
	set_deferred("monitorable", false)

func sword_attack_audio():
	if audio.stream != sword_attack:
		audio.stream = sword_attack
	audio.play()

func shade_begin():
	set_deferred("monitorable", true)
	knockback_vector = Vector2.ZERO
	orig_damage = damage
	damage = modify_damage(damage, 3)

func shade_end():
	reset_damage()

func flash_whoosh_audio():
	audio.stream = flash_whoosh
	audio.play()

func flash_begin():
	audio.stream = flash_swing
	audio.play()
	$CollisionShape2D.scale.x = 2
	set_deferred("monitorable", true)
	knockback_vector *= 1.5
	orig_damage = damage
	damage = modify_damage(damage, 2)

func flash_end():
	reset_damage()
