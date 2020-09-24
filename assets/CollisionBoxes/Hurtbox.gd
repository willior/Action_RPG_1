extends Area2D

# 1. when something gets hit, that object runs the start_invincibility(duration) function
# 2. this sets the boolean invincible to TRUE, and starts the timer(duration)
# 3. when the boolean invincible is changed, runs the function set_invincible(value)
# 4. if value = true, emits the signal "invincibility_started"
# 5. if value = false, emits the signal "invincibility_ended"
# 6. those signals reach the game object and play/stop the appropriate animations
# 6B. those signals also enable / disable the hitbox for the duration
# ISSUE: if two hitboxes are in the hurtbox on the same frame, both are calculated

const HitEffect = preload("res://assets/Effects/HitEffect.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collision = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		
func start_invincibility(duration):
	collision.set_deferred("disabled", true)
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	print('hit')
	var effect = HitEffect.instance()
	
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false # if self prefixes invincible, calls the setter

func _on_Hurtbox_invincibility_started(): pass

func _on_Hurtbox_invincibility_ended():
	collision.set_deferred("disabled", false)
