extends Area2D

onready var flash_whoosh = preload("res://assets/Audio/Sword_Flash_Whoosh.wav")
onready var flash_swing = preload("res://assets/Audio/Sword_Flash_Swing.wav")
onready var audio = $AudioStreamPlayer

onready var damage = PlayerStats.strength setget set_damage
onready var damage_mod = PlayerStats.strength_mod setget set_damage_mod
# onready var shade_mod = PlayerStats.strength_mod setget set_shade_mod

var knockback_vector = Vector2.ZERO
var orig_damage
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_changed", self, "set_damage")
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_mod_changed", self, "set_damage_mod")
	orig_damage = damage

func set_damage(_damage):
	damage = PlayerStats.strength
	# calculate_damage(PlayerStats.strength, damage_mod)
	
func set_damage_mod(_damage_mod):
	damage_mod = PlayerStats.strength_mod

func calculate_damage(base, modulator):
	damage = int((base + modulator))
	
func modify_damage(base, modulator):
	damage = (base * modulator)
	
func reset_damage():
	damage = orig_damage
	
func shade_begin():
	set_deferred("monitorable", true)
	knockback_vector = Vector2.ZERO
	orig_damage = damage
	modify_damage(damage, 3)
	
func shade_end():
	set_deferred("monitorable", false)
	damage = orig_damage
	
func flash_whoosh_audio():
	audio.stream = flash_whoosh
	audio.play()
	
func flash_begin():
	audio.stream = flash_swing
	audio.play()
	$CollisionShape2D.scale.x = 1.5
	set_deferred("monitorable", true)
	knockback_vector *= 1.5
	orig_damage = damage
	modify_damage(damage, 2)
	
func flash_end():
	$CollisionShape2D.scale.x = 1
	set_deferred("monitorable", false)
	damage = orig_damage
