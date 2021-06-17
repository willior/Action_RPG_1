extends Area2D

onready var sword_attack = preload("res://assets/Audio/Player/Sword_Attack_1.wav")
onready var flash_whoosh = preload("res://assets/Audio/Player/Sword_Flash_Whoosh.wav")
onready var flash_swing = preload("res://assets/Audio/Player/Sword_Flash_Swing.wav")
onready var audio = $AudioStreamPlayer

var base_damage = 4
var damage
var orig_damage
var randomness = 0.16
var knockback_vector = Vector2.ZERO
var status
var orig_status
var status_two # = ["Poison", 0.5]
var stats

func _ready():
	stats = get_parent().get_parent().stats
# warning-ignore:return_value_discarded
	stats.connect("strength_changed", self, "set_damage")
	damage = base_damage + stats.strength
	orig_damage = damage
	orig_status = status

func set_damage(value):
	damage = base_damage + value
	orig_damage = damage
	orig_status = status
	print('STR increased. new damage set = ', damage)

func modify_damage(base, modulator):
	return int(base * modulator)

func reset_damage():
	stats.dexterity_mod = 0
	damage = orig_damage
	status = orig_status
	$CollisionShape2D.scale.x = 1
	set_deferred("monitorable", false)

func sword_attack_audio():
	if audio.stream != sword_attack:
		audio.stream = sword_attack
	audio.play()

func enable_sword_hitbox(time=0.1):
	set_deferred("monitorable", true)
	$HitboxTimer.start(time)
	yield($HitboxTimer, "timeout")
	set_deferred("monitorable", false)

func shade_begin():
	enable_sword_hitbox(0.3)
	knockback_vector = Vector2.ZERO
	stats.dexterity_mod = 8
	orig_damage = damage
	damage = modify_damage(damage, 3)

func flash_whoosh_audio():
	audio.stream = flash_whoosh
	audio.play()

func flash_begin():
	audio.stream = flash_swing
	audio.play()
	$CollisionShape2D.scale.x = 2
	enable_sword_hitbox()
	knockback_vector *= 1.33
	stats.dexterity_mod = 4
	orig_damage = damage
	damage = modify_damage(damage, 2)
	status = ["Stun", 1.0]
