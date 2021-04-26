extends Node2D
onready var EnemyTarget = load("res://assets/UI/Target/EnemyTarget.tscn")
onready var sfx1 = get_tree().get_root().get_node("World/SFX")
onready var sfx2 = get_tree().get_root().get_node("World/SFX2")
var enemies
var count

func _ready():
	# self.position = Vector2(160, 90)
	sfx1.stream_paused = true
	sfx2.stream_paused = true
	get_tree().paused = true
	Physics2DServer.set_active(true)
	count = 0
	
	enemies = get_tree().get_nodes_in_group("Enemies")
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
	if event.is_action_pressed("pause"): # P
		end_target_screen()
	
	if event.is_action_pressed("attack"):
		end_target_screen()
	
	if event.is_action_pressed("next_item"):
		if enemies.size() <= 0:
			return
		if count >= enemies.size():
			count = 0
		$TargetArea.global_position = enemies[count].global_position
		count += 1
	
	get_tree().set_input_as_handled()

func end_target_screen():
		sfx1.stream_paused = false
		sfx2.stream_paused = false
		get_tree().paused = false
		for c in get_tree().get_root().get_node("World/Targets").get_children():
			c.queue_free()
		queue_free()

func _on_TargetArea_body_entered(body):
	$TargetArea.modulate = Color(1,0,0,0.5)
	body.modulate = Color(1,0,0,0.5)

func _on_TargetArea_body_exited(body):
	body.modulate = Color(1,1,1,0.5)
	if $TargetArea.get_overlapping_bodies().size() == 1:
		$TargetArea.modulate = Color(1,1,1,0.5)
