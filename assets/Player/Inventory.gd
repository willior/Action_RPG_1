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
		
	var remaining_quantity = quantity
	var max_stack_size = item.max_stack_size if item.stackable else 1
	
	if item.stackable:
		for i in range(_items.size()):
			if remaining_quantity == 0:
				# if we don't have any more items to add, break straight out
				break
			
			# creating a reference to the current loop's item index
			var inventory_item = _items[i]
			
			# goes to next loop if it is not the item we're concerned with
			if inventory_item.item_reference.name != item.name:
				continue
			
			# create a reference to the inventory_item's current quantity, original_quantity
			# sets the quantity of the inventory_item to whichever is smaller:
			# the original_quantity + remaining_quantity...
			# OR the item's max_stack_size.
			# subtracts from remaining_quantity the difference between
			# the item's old and new quantites
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
	
	# while there are items remaining, create a new stack
	# chooses the lowest value between remaining_quanity & max_stack_size
	# applies this value to the new_item and appends it to the _items Array
	# then subtracts the value (new_item.quantity) from remaining_quantity
	while remaining_quantity > 0:
		var new_item = {
			item_reference = item,
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.append(new_item)
		remaining_quantity -= new_item.quantity
		
	emit_signal("inventory_changed", self)
