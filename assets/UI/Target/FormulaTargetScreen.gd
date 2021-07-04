extends Control

# types of targetting:
# 0: static AoE circle (Nova)
# 1: free target AoE circle (Flash)
# 2: single-target line (Hardball)
# 3: multi-target line (Laser)

# formula target sizes:
# 0: tiny 16x16
# 1: small 32x32
# 2: medium 64x64
# 3: large 128x128
# 4: huge 256x256
# 5: screen everything

onready var Target = load("res://assets/UI/Target/Target.tscn")
onready var music = get_tree().get_root().get_node("World/Music")
onready var sfx1 = get_tree().get_root().get_node("World/SFX")
onready var sfx2 = get_tree().get_root().get_node("World/SFX2")
onready var target_shape = $KinematicBody2D/TargetArea/CollisionShape2D
onready var target_sprite = $KinematicBody2D/TargetArea/Sprite
onready var target_area = $KinematicBody2D/TargetArea
onready var target_body = $KinematicBody2D

onready var player = get_parent().player
var target_bodies
var group_to_target : String
var target_color : Color
var count

var target_size
enum targetMode { NONE, FREE, ANGLE }
export(targetMode) var target_mode
export var formula_range : int
export var attack_formula : bool

var up
var down
var left
var right
var next
var previous

var velocity = Vector2.ZERO
var ending = false

func _ready():
	Global.target_screen_open = true
	get_tree().paused = true
	match player.name:
		"Player":
			up = "up_1"
			down = "down_1"
			left = "left_1"
			right = "right_1"
			next = "next_1"
			previous = "previous_1"
		"Player2":
			up = "up_2"
			down = "down_2"
			left = "left_2"
			right = "right_2"
			next = "next_2"
			previous = "previous_2"
	sfx1.stream_paused = true
	sfx2.stream_paused = true
	AudioServer.set_bus_effect_enabled(0, 0, true)
	Physics2DServer.set_active(true)
	count = 0
	if attack_formula:
		target_color = Color(1,0,0,1)
		group_to_target = "Enemies"
	else:
		target_color = Color(0,1,1,1)
		group_to_target = "Players"
	target_bodies = get_tree().get_nodes_in_group(group_to_target)
	target_bodies.sort_custom(self, "sort_target_bodies")
	var targets = Node.new()
	targets.set_name("Targets")
	get_tree().get_root().get_node("World").add_child(targets)
	for e in range(0, target_bodies.size()):
		var target = Target.instance()
		target.global_position = target_bodies[e].hurtbox.get_child(0).global_position
		get_tree().get_root().get_node("World/Targets").add_child(target)
	var closest_target
	if target_bodies.size() > 0:
		closest_target = target_bodies[0].hurtbox.get_child(0)
	if target_mode == 0 or target_mode == 1:
		target_size = get_parent().formula_size
		match target_size:
			0:
				target_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_8.tres")
				target_sprite.texture = load("res://assets/UI/Target/Ring_0_TINY_16.png")
				formula_range += 24
			1:
				target_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_16.tres")
				target_sprite.texture = load("res://assets/UI/Target/Ring_1_SMALL_32.png")
				formula_range += 16
			2:
				target_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_32.tres")
				target_sprite.texture = load("res://assets/UI/Target/Ring_2_MEDIUM_64.png")
			3:
				target_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_64.tres")
				target_sprite.texture = load("res://assets/UI/Target/Ring_3_LARGE_128.png")
				formula_range -= 32
			4:
				target_shape.shape = load("res://assets/CollisionBoxes/Circles/Circle_128.tres")
				target_sprite.texture = load("res://assets/UI/Target/Ring_4_HUGE_256.png")
				formula_range -= 96
			5:
				pass
	elif target_mode == 2:
		target_sprite.centered = false
		target_sprite.texture = load("res://assets/UI/Target/Line_1_SMALL.png")
		if target_bodies.size() == 0:
			begin_animate_target()
			return
		for t in range(0, target_bodies.size()):
			if get_parent().global_position.distance_to(target_bodies[t].global_position) < get_parent().global_position.distance_to(closest_target.global_position):
				closest_target = target_bodies[t].hurtbox.get_child(0)
				# print('new closest target: ', closest_target.get_parent().get_parent().name)
				count = t
		target_body.look_at(closest_target.global_position)
	begin_animate_target()

func sort_target_bodies(a, b):
	if target_mode == 1 and a.position.x < b.position.x:
		return true
	elif target_mode == 2 and get_parent().global_position.angle_to_point(a.hurtbox.get_child(0).global_position) < get_parent().global_position.angle_to_point(b.hurtbox.get_child(0).global_position):
		return true
	return false

func begin_animate_target():
	$Tween.interpolate_property(self,
	"modulate",
	Color(1,1,1,0),
	Color(1,1,1,1),
	0.25,
	Tween.TRANS_QUART,
	Tween.EASE_OUT
	)
	$Tween.interpolate_property($KinematicBody2D/TargetArea/Sprite,
	"scale",
	Vector2(4,4),
	Vector2(1,1),
	0.25,
	Tween.TRANS_QUART,
	Tween.EASE_OUT
	)
#	$Tween.interpolate_property($KinematicBody2D/TargetArea/Sprite2,
#	"scale",
#	Vector2(4,4),
#	Vector2(1,1),
#	0.25,
#	Tween.TRANS_QUART,
#	Tween.EASE_OUT
#	)
	$Tween.start()

func end_animate_target():
	ending = true
	$Tween.interpolate_property(self,
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),
	0.25,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
	$Tween.interpolate_property($KinematicBody2D/TargetArea/Sprite,
	"scale",
	Vector2(1,1),
	Vector2(4,4),
	0.25,
	Tween.TRANS_QUART,
	Tween.EASE_IN
	)
#	$Tween.interpolate_property($KinematicBody2D/TargetArea/Sprite2,
#	"scale",
#	Vector2(1,1),
#	Vector2(4,4),
#	0.25,
#	Tween.TRANS_QUART,
#	Tween.EASE_IN
#	)
	$Tween.start()

func _process(_delta):
	match target_mode:
		1:
			if ending: return
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
			target_body.position = target_body.position.clamped(formula_range)
		2:
			if ending: return
			if Input.is_action_pressed(right):
				target_body.rotation_degrees += 2
			if Input.is_action_pressed(left):
				target_body.rotation_degrees -= 2
			if Input.is_action_pressed(down):
				target_body.rotation_degrees += 2
			if Input.is_action_pressed(up):
				target_body.rotation_degrees -= 2

func _input(event):
	if ending:
		get_tree().set_input_as_handled()
		return
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
				"BraceLeft":
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
				"T": 
					get_tree().set_input_as_handled()
					return
				"Space":
					get_tree().set_input_as_handled()
					return
	get_tree().set_input_as_handled()
	
	if event.is_action_pressed("ui_accept"):
		get_parent().start(player, get_parent().formula_used)
		if target_mode == 0 or target_mode == 1:
			get_parent().get_node("FormulaHitbox").position = target_body.position
		elif target_mode == 2:
			get_parent().get_node("FormulaHitbox").rotation_degrees = target_body.rotation_degrees
		end_target_screen()
	
	if event.is_action_pressed("ui_cancel"):
		end_animate_target()
		yield($Tween, "tween_all_completed")
		cancel_target_screen()
	if event.is_action_pressed(next):
		next_target_body()
	if event.is_action_pressed(previous):
		previous_target_body()

func next_target_body():
	if target_bodies.size() <= 0:
		print('no target_bodies detected')
		return
	count += 1
	if count >= target_bodies.size():
		count = 0
	if target_body_out_of_range():
		print(target_bodies[count].name, ' target_body out of range; skipping')
		target_bodies.remove(count)
		count -= 1
		next_target_body()
		return
	if target_mode == 1:
		target_body.global_position = target_bodies[count].hurtbox.get_child(0).global_position
	elif target_mode == 2:
		target_body.look_at(target_bodies[count].hurtbox.get_child(0).global_position)

func previous_target_body():
	if target_bodies.size() <= 0:
		print('no target_bodies detected')
		return
	count -= 1
	if count < 0:
		count = target_bodies.size()-1
	if target_body_out_of_range():
		print(target_bodies[count].name, ' target_body out of range; skipping')
		target_bodies.remove(count)
		count -= 1
		previous_target_body()
		return
	if target_mode == 1:
		target_body.global_position = target_bodies[count].hurtbox.get_child(0).global_position
	elif target_mode == 2:
		target_body.look_at(target_bodies[count].hurtbox.get_child(0).global_position)

func target_body_out_of_range():
	if target_mode == 1:
		if player.global_position.distance_to(target_bodies[count].hurtbox.get_child(0).global_position) > formula_range + target_shape.shape.radius + 4:
			return true
	elif target_mode == 2:
		if player.global_position.distance_to(target_bodies[count].hurtbox.get_child(0).global_position) > formula_range + 4:
			return true

func cancel_target_screen():
	end_target_screen()
	get_parent().queue_free()

func end_target_screen():
	Global.target_screen_open = false
	end_animate_target()
	sfx1.stream_paused = false
	sfx2.stream_paused = false
	AudioServer.set_bus_effect_enabled(0, 0, false)
	get_tree().paused = false
	get_tree().get_root().get_node("World/Targets").queue_free()
	yield($Tween, "tween_all_completed")
	queue_free()

func _on_TargetArea_body_entered(body):
	target_area.modulate = target_color
	body.modulate = target_color

func _on_TargetArea_body_exited(body):
	body.modulate = Color(1,1,1,1)
	if target_area.get_overlapping_bodies().size() == 0:
		target_area.modulate = Color(1,1,1,1)
