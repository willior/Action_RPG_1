extends Node
# ItemDatabase

# ItemDatabase class loops through Items folder
# loading every resource into an array called items
# iterate through items Array
# returns any item with a matching name

var items = Array()

func _ready():
	var directory = Directory.new()
	directory.open("res://assets/Resources/ItemResources")
	directory.list_dir_begin()
	
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir():
			items.append(load("res://assets/Resources/ItemResources/%s" % filename))
			
		filename = directory.get_next()

func get_item(item_name):
	for i in items:
		if i.name == item_name:
			return i
	
	return null
