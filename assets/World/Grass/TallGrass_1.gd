extends Node2D

const EFFECT = preload("res://assets/Effects/TallGrass_Effect.tscn")

onready var sprite = $AnimatedSprite

func _ready():
	sprite.frame = randi() % 5
	sprite.playing = true

func create_effect():
	sprite.play("Cut")
	var effect = EFFECT.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position

func _on_Hurtbox_area_entered(_area):
	create_effect()
	$Hurtbox.queue_free()
