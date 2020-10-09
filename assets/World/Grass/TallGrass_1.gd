extends Node2D

const EFFECT = preload("res://assets/Effects/TallGrass_Effect.tscn")

onready var sprite = $AnimatedSprite

var cutCount = 0

func _ready():
	randomize()
	sprite.frame = randi() % 5
	sprite.playing = true
	sprite.flip_h = randi() % 2

func create_effect():
	cutCount += 1
	var effect = EFFECT.instance()
	get_parent().add_child(effect)
	effect.global_position = global_position
	if sprite.flip_h:
		effect.flip_h = true
	if cutCount == 1:
		sprite.play("Cut")
	elif cutCount == 2:
		sprite.play("CutComplete")
		sprite.playing = false
		effect.global_position.y += 8

func _on_Hurtbox_area_entered(_area):
	create_effect()
	if cutCount == 2:
		$Hurtbox.queue_free()
