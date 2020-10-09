extends Area2D

onready var damage = PlayerStats.strength setget set_strength
onready var damage_mod = PlayerStats.strength_mod setget set_strength_mod

onready var flash_whoosh = preload("res://assets/Audio/Sword_Flash_Whoosh.wav")
onready var flash_swing = preload("res://assets/Audio/Sword_Flash_Swing.wav")
onready var audio = $AudioStreamPlayer

var knockback_vector = Vector2.ZERO
var orig_damage

func _ready():
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_changed", self, "set_strength")
# warning-ignore:return_value_discarded
	PlayerStats.connect("strength_mod_changed", self, "set_strength_mod")

func set_strength(_strength):
	damage = PlayerStats.strength
	
func set_strength_mod(_strength_mod):
	damage_mod = PlayerStats.strength_mod
	damage += damage_mod
	
func shade_begin():
	set_deferred("monitorable", true)
	knockback_vector = Vector2.ZERO
	orig_damage = damage
	
func shade_end():
	set_deferred("monitorable", false)
	damage = orig_damage
	damage_mod = 0
	
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
	
func flash_end():
	$CollisionShape2D.scale.x = 1
	set_deferred("monitorable", false)
	damage = orig_damage
	damage_mod = 0
