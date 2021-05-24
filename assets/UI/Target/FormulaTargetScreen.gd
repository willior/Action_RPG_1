extends Control
onready var EnemyTarget = load("res://assets/UI/Target/EnemyTarget.tscn")
onready var music = get_tree().get_root().get_node("World/Music")
onready var sfx1 = get_tree().get_root().get_node("World/SFX")
onready var sfx2 = get_tree().get_root().get_node("World/SFX2")
onready var target_area = $KinematicBody2D/TargetArea
onready var target_body = $KinematicBody2D
var player
var enemies
var count
export var formula_range : int
export var formula_shape : Shape2D
export var formula_size : int
var up
var down
var left
var right
var next
var velocity = Vector2.ZERO
func _ready():
	player = get_parent().player
	match player.name:
		"Player":
			up = "up_1"
			down = "down_1"
			left = "left_1"
			right = "right_1"
			next = "next_1"
		"Player2":
			up = "up_2"
			down = "down_2"
			left = "left_2"
			right = "right_2"
			next = "next_2"
	sfx1.stream_paused = true
	sfx2.stream_paused = true
	AudioServer.set_bus_effect_enabled(0, 0, true)
#	Engine.time_scale = 0.1
	get_tree().paused = true
	Physics2DServer.set_active(true)
	count = 0
	enemies = get_tree().get_nodes_in_group("Enemies")
	var targets = Node.new()
	targets.set_name("Targets")
	get_tree().get_root().get_node("World").add_child(targets)
	for e in range(0, enemies.size()):
		var enemy_target = EnemyTarget.instance()
		enemy_target.global_position = enemies[e].global_position
		get_tree().get_root().get_node("World/Targets").add_child(enemy_target)

func _process(_delta):
	velocity = Vector2()
	if Input.is_action_pressed(right):
		velocity.x += 1
	if Input.is_action_pressed(left):
		velocity.x -= 1
	if Input.is_action_pressed(down):
		velocity.y += 1
	if Input.is_action_pressed(up):
		velocity.y -= 1
	velocity = velocity.normalized()*160
	velocity = target_body.move_and_slide(velocity)
#	var input_vector = Vector2.ZERO
#	input_vector.x = Input.get_action_strength(right) - Input.get_action_strength(left)
#	input_vector.y = Input.get_action_strength(down) - Input.get_action_strength(up)
#	input_vector = input_vector.normalized()
#	velocity = input_vector*100
#	target_area.position.move_toward(velocity, _delta*100)
	target_body.position = target_body.position.clamped(135)

func _input(event):
	match player.name:
		"Player":
			match event.as_text():
				"I":
					get_tree().set_input_as_handled()
					return
				"J":
					get_tree().set_input_as_handled()
					return
				"K":
					get_tree().set_input_as_handled()
					return
				"L":
					get_tree().set_input_as_handled()
					return
				"P":
					get_tree().set_input_as_handled()
					return
				"Slash":
					get_tree().set_input_as_handled()
					return
				"Shift":
					get_tree().set_input_as_handled()
					return
				"Semicolon":
					get_tree().set_input_as_handled()
					return
				"Enter":
					get_tree().set_input_as_handled()
					return
		"Player2":
			match event.as_text():
				"W":
					get_tree().set_input_as_handled()
					return
				"S": 
					get_tree().set_input_as_handled()
					return
				"A": 
					get_tree().set_input_as_handled()
					return
				"D": 
					get_tree().set_input_as_handled()
					return
				"V": 
					get_tree().set_input_as_handled()
					return
				"B": 
					get_tree().set_input_as_handled()
					return
				"F": 
					get_tree().set_input_as_handled()
					return
				"R": 
					get_tree().set_input_as_handled()
					return
				"Space":
					get_tree().set_input_as_handled()
					return
	get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_accept"):
		get_parent().start()
		get_parent().get_node("FormulaHitbox").position = target_body.position
		end_target_screen()
	if event.is_action_pressed("ui_cancel"):
		cancel_target_screen()
	if event.is_action_pressed(next):
		next_enemy()

func next_enemy():
	if enemies.size() <= 0:
		print('no enemies detected')
		return
	count += 1
	if count >= enemies.size():
		count = 0
	if enemy_out_of_range():
		print(enemies[count].name, ' enemy out of range; skipping')
		enemies.remove(count)
		count -= 1
		next_enemy()
		return
	target_area.global_position = enemies[count].global_position

func enemy_out_of_range():
	if get_tree().get_root().get_node("World/YSort/Player").position.distance_to(enemies[count].position) > 184:
		return true

func cancel_target_screen():
	end_target_screen()
	get_parent().queue_free()

func end_target_screen():
	sfx1.stream_paused = false
	sfx2.stream_paused = false
	AudioServer.set_bus_effect_enabled(0, 0, false)
#	Engine.time_scale = 1
	get_tree().paused = false
	get_tree().get_root().get_node("World/Targets").queue_free()
	queue_free()

func _on_TargetArea_body_entered(body):
	target_area.modulate = Color(1,0,0,1)
	body.modulate = Color(1,0,0,1)

func _on_TargetArea_body_exited(body):
	body.modulate = Color(1,1,1,1)
	if target_area.get_overlapping_bodies().size() == 0:
		target_area.modulate = Color(1,1,1,1)
