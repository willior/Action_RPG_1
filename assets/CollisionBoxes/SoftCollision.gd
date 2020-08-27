extends Area2D

func is_colliding():
	var areas = get_overlapping_areas() # gets the array of overlapping areas and stores it in var areas
	return areas.size() > 0 # returns true if the array's size is greater than 0
	
func get_push_vector():
	var areas = get_overlapping_areas() # gets the array of overlapping areas and stores it in var areas
	var push_vector = Vector2.ZERO # initializes the var push_vector
	if is_colliding(): # checks if the areas array is greater than 0, ie. if the areas are overlapping
		var area = areas[0] # gets the FIRST area overlap and stores it in var area
		push_vector = area.global_position.direction_to(global_position) # getting a vector that goes from ITS global position to OUR global position
		push_vector = push_vector.normalized()
	return push_vector # will return 0 if not colliding with anything
