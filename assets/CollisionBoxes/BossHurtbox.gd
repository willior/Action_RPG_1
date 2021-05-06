extends Area2D

const HitEffect = preload("res://assets/Effects/HitEffect.tscn")
const DamagePopup = preload("res://assets/UI/Popups/DamagePopup.tscn")
onready var timer = $Timer
onready var collision = $CollisionShape2D
onready var main = get_tree().get_root().get_node("World")
var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	main.add_child(effect)
	effect.global_position = global_position
	
func display_damage_popup(value, crit, kind="Normal"):
	var damagePopup = DamagePopup.instance()
	damagePopup.damageDisplay = value
	damagePopup.is_crit = crit
	damagePopup.kind = kind
	get_parent().get_node("CanvasLayer/BossHealth/DamageContainer").add_child(damagePopup)

func _on_Timer_timeout():
	self.invincible = false # if self prefixes invincible, calls the setter

func _on_Hurtbox_invincibility_started(): pass
	# collision.set_deferred("disabled", true)
	
func _on_Hurtbox_invincibility_ended(): pass
	# collision.set_deferred("disabled", false)
