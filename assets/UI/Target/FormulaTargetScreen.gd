extends Control
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
	if event.is_action_pressed("ui_accept"): # or event.is_action_pressed("alchemy"):
		get_parent().start()
		get_parent().get_node("FormulaHitbox").position = $TargetArea.position
		end_target_screen()
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("examine"):
		cancel_target_screen()
	if event.is_action_pressed("next"):
		next_enemy()

func next_enemy():
	if enemies.size() <= 0:
		print('no enemies detected')
		return
	count += 1
	if count >= enemies.size():
		count = 0
	if enemy_out_of_range():
		print(enemies[count], ' enemy out of range; skipping')
		enemies.remove(count)
		count -= 1
		next_enemy()
		return
	$TargetArea.global_position = enemies[count].global_position

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
	$TargetArea.modulate = Color(1,0,0,1)
	body.modulate = Color(1,0,0,1)

func _on_TargetArea_body_exited(body):
	body.modulate = Color(1,1,1,1)
	if $TargetArea.get_overlapping_bodies().size() == 1:
		$TargetArea.modulate = Color(1,1,1,1)
