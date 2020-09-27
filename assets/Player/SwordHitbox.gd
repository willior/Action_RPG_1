extends Area2D

onready var damage = PlayerStats.strength setget set_strength
onready var hurtbox = $Hurtbox
var knockback_vector = Vector2.ZERO
var orig

func _ready():
	PlayerStats.connect("strength_changed", self, "set_strength")

func set_strength(strength):
	damage = PlayerStats.strength
	
func shade_begin():
	# get_node("/root/World/YSort/Player/Hurtbox").start_invincibility(0.4)
	knockback_vector = Vector2.ZERO
	orig = damage
	damage += 4
	
func shade_end():
	damage = orig
