extends Node2D

func _ready():
	pass
	# $AudioStreamPlayer.play()

func _input(event):
	if event.is_action_pressed("quit_game"):
		GameManager.quit_to_title()
	
	if event.is_action_pressed("test1"):
		$AudioStreamPlayer.stream_paused = false
		#$AudioStreamPlayer.playing = true
		print("audio not paused")
		
	if event.is_action_pressed("test2"):
		#$AudioStreamPlayer.stream_paused = true
		#$AudioStreamPlayer.playing = false
		print("audio paused")
		
	if event.is_action_pressed("test3"):
		print('unpausing SceneTree...')
		print($AudioStreamPlayer.stream_paused)
		get_tree().paused = false
		print($AudioStreamPlayer.stream_paused)
		print("tree not paused")
		
	if event.is_action_pressed("test4"):
		get_tree().paused = true
		print('tree paused')
