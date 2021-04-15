extends Node2D

const EnemyDeathEffect = preload("res://assets/Effects/EnemyDeathEffect.tscn")
const ExpNotice = preload("res://assets/UI/ExpNotice.tscn")
const DialogBox = preload("res://assets/UI/DialogBox.tscn")
const IngredientPickup = preload("res://assets/Ingredients/IngredientPickup.tscn")
var EnemySpawner = preload("res://assets/Spawners/EnemySpawner.tscn")

# GENERIC ENEMY CLASS / REFACTOR PROJECT

# common elements of the bat & crow go into a generic enemy class.
# if their values need to be modified, export the appropriate variables.
# the “bat” & “crow” classes, after their shared code has been refactored,
# should extend this generic “enemy” class.

func h_flip_handler(sprite, eye, velocity):
	sprite.flip_h = velocity.x < 0
	eye.flip_h = velocity.x < 0

func set_player_collision(body):
	var player = get_node("/root/World/YSort/Player")
	if player.z_index == body.z_index:
		body.set_collision_layer_bit(4, true)
		body.disable_detection()
		body.enable_detection()
	else:
		body.set_collision_layer_bit(4, false)

func examine(dialog_script):
	var dialogBox = DialogBox.instance()
	dialogBox.dialog_script = dialog_script
	get_node("/root/World/GUI").add_child(dialogBox)
	
#	if !examined:
#		examined = true
#		PlayerLog.bat_examined = true
#		PlayerLog.set_examined("bat", true)
