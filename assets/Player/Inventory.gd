extends Resource
class_name Inventory

signal inventory_changed

export var _items = Array() setget set_items, get_items

func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", self)
	
func get_items():
	return _items
	
func get_item(index):
	return _items[index]
	
func add_item(item_name, quantity):
	if quantity <= 0:
		print("can't add negative number of items")
		return
	
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("could not find item")
		return
