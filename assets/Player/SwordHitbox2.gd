extends Area2D

onready var sword_attack = preload("res://assets/Audio/Player/Sword_Attack_1.wav")
onready var flash_whoosh = preload("res://assets/Audio/Player/Sword_Flash_Whoosh.wav")
onready var flash_swing = preload("res://assets/Audio/Player/Sword_Flash_Swing.wav")
onready var audio = $AudioStreamPlayer
onready var damage = Player2Stats.strength*2 setget set_damage
# onready var damage_mod = Player2Stats.strength_mod setget set_damage_mod
# onready var shade_mod = Player2Stats.strength_mod setget set_shade_mod
var knockback_vector = Vector2.ZERO
var orig_damage
var randomness = 0.25
var player_no = 2

func _ready():
# warning-ignore:return_value_discarded
	Player2Stats.connect("strength_changed", self, "set_damage")
# warning-ignore:return_value_discarded
#	Player2Stats.connect("strength_mod_changed", self, "set_damage_mod")
	orig_damage = damage

func set_damage(value):
	damage = value
	
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
	knockback_vector *= 1.33
	orig_damage = damage
	damage = modify_damage(damage, 2)
	
func flash_end():
	reset_damage()
