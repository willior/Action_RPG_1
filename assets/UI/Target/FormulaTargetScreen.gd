extends Node2D
onready var EnemyTarget = load("res://assets/UI/Target/EnemyTarget.tscn")
onready var music = get_tree().get_root().get_node("World/Music")
onready var sfx1 = get_tree().get_root().get_node("World/SFX")
onready var sfx2 = get_tree().get_root().get_node("World/SFX2")
var enemies
var count
export var formula_range : int
export var formula_shape : Shape2D
export var formula_size : int

func _ready():
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
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength ("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	$TargetArea.position += input_vector*2
	if $TargetArea.position.x > 160:
		$TargetArea.position.x = 160
	if $TargetArea.position.x < -160:
		$TargetArea.position.x = -160
	if $TargetArea.position.y > 90:
		$TargetArea.position.y = 90
	if $TargetArea.position.y < -90:
		$TargetArea.position.y = -90

func _input(event):
	get_tree().set_input_as_handled()
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("alchemy"):
		get_parent().start()
		get_parent().get_node("FormulaHitbox").position = $TargetArea.position
		end_target_screen()
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("examine"):
		cancel_target_screen()
	if event.is_action_pressed("next"):
		if enemies.size() <= 0:
			return
		if count >= enemies.size():
			count = 0
		$TargetArea.global_position = enemies[count].global_position
		count += 1

func cancel_target_screen():
	get_parent().cancelled = true
	get_parent().queue_free()
	end_target_screen()

func end_target_screen():
	sfx1.stream_paused = false
	sfx2.stream_paused = false
	AudioServer.set_bus_effect_enabled(0, 0, false)
#	Engine.time_scale = 1
	get_tree().paused = false
	get_tree().get_root().get_node("World/Targets").queue_free()
	queue_free()

func _on_TargetArea_body_entered(body):
	$TargetArea.modulate = Color(1,0,0,0.5)
	body.modulate = Color(1,0,0,0.5)

func _on_TargetArea_body_exited(body):
	body.modulate = Color(1,1,1,0.5)
	if $TargetArea.get_overlapping_bodies().size() == 1:
		$TargetArea.modulate = Color(1,1,1,0.5)
