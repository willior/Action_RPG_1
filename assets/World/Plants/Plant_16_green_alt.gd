extends StaticBody2D

const EFFECT1 = preload("res://assets/Effects/Environment/Plant_16_Cut1_Effect.tscn")
const EFFECT2 = preload("res://assets/Effects/Environment/Plant_16_Cut2_Effect.tscn")
const EFFECT3 = preload("res://assets/Effects/Environment/Plant_16_Cut3_Effect.tscn")
const EFFECT4 = preload("res://assets/Effects/Environment/Plant_16_Cut4_Effect.tscn")
onready var sprite = $Sprite
var effect
var cutCount = 0

func _ready():
	randomize()
	sprite.flip_h = randi() % 2

func create_effect():
	cutCount += 1
	if cutCount == 1:
		sprite.frame = 1
		effect = EFFECT1.instance()
	elif cutCount == 2:
		sprite.frame = 2
		effect = EFFECT2.instance()
	elif cutCount == 3:
		sprite.frame = 3
		effect = EFFECT3.instance()
	elif cutCount == 4:
		sprite.frame = 4
		effect = EFFECT4.instance()
		
	if sprite.flip_h:
		effect.flip_h = true

	get_parent().add_child(effect)
	effect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	create_effect()
	if cutCount == 4:
		$Hurtbox.queue_free()
		$ShadowSprite.queue_free()
		$CollisionShape2D.queue_free()
