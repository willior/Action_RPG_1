extends Area2D

onready var damage = PlayerStats.strength setget set_strength
onready var damage_mod = PlayerStats.strength_mod setget set_strength_mod

var knockback_vector = Vector2.ZERO
var orig

func _ready():
	PlayerStats.connect("strength_changed", self, "set_strength")
	PlayerStats.connect("strength_mod_changed", self, "set_strength_mod")

func set_strength(strength):
	damage = PlayerStats.strength
	
func set_strength_mod(strength_mod):
	damage_mod = PlayerStats.strength_mod
	damage += damage_mod
	
func shade_begin():
	knockback_vector = Vector2.ZERO
	orig = damage
	
func shade_end():
	damage = orig
	damage_mod = 0
	
func flash_begin():
	$CollisionShape2D.scale.x = 3
	knockback_vector *= 1.5
	orig = damage
	
func flash_end():
	$CollisionShape2D.scale.x = 1
	damage = orig
	damage_mod = 0
