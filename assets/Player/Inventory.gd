extends Resource
class_name Inventory
# Inventory

signal inventory_changed
signal current_selected_item_changed
signal selected_item_quantity_updated
signal item_quantity_zero

export var _items = Array() setget set_items, get_items

var current_selected_item = 0
var items_set = false

func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", self)
	var new_selected_item = get_item(current_selected_item)
	
	emit_signal("current_selected_item_changed", new_selected_item)

func get_items():
	return _items
	
func get_item(index):
	return _items[index]
	
func advance_selected_item():
	if _items.size() == 1:
		GameManager.player.audio.stream = load("res://assets/Audio/Bamboo.wav")
		GameManager.player.audio.play()

	else:
		GameManager.player.audio.stream = load("res://assets/Audio/Player/Item_Next.wav")
		GameManager.player.audio.play()
		current_selected_item += 1
		if current_selected_item >= _items.size():
			current_selected_item = 0
		var new_selected_item = get_item(current_selected_item)
		emit_signal("current_selected_item_changed", new_selected_item)
	
func check_item(item_name, quantity):
	if quantity <= 0:
		GameManager.player.audio.stream = load("res://assets/Audio/Bamboo.wav")
		GameManager.player.audio.play()
		print("quantity is 0 or less; returning")
		return
	
	var item = ItemDatabase.get_item(item_name)
	if not item:
		print("could not find item")
		return
		
	return item
	
func use_item():
	var used_item = check_item(_items[current_selected_item].item_reference.name, _items[current_selected_item].quantity)
	if used_item:
		if used_item.type == 0:
			# removes item from inventory if it is a consumable
			remove_item(used_item.name, 1)
			
		ItemHandler.item_handler(used_item)
	
func remove_item(item_name, quantity):
	prints("removing " + str(quantity) + " " + str(item_name))
	
	for i in range(_items.size()):
		var inventory_item = _items[i]
		
		if inventory_item.item_reference.name != item_name:
			print('next loop')
			continue
			
		if inventory_item.quantity <= 0:
			print("none left")
			return
		else: 
			inventory_item.quantity -= quantity
			if inventory_item.quantity <= 0 && inventory_item.item_reference.name != "Potion":
				emit_signal("item_quantity_zero")
				prints(str(inventory_item.item_reference.name) + " cleared from inventory")
				_items.erase(get_item(current_selected_item))
				current_selected_item = 0
			else:
				var updated_selected_item = get_item(current_selected_item)
				emit_signal("selected_item_quantity_updated", updated_selected_item)
	
func add_item(item_name, quantity):
	prints("adding " + str(quantity) + " " + str(item_name))
	
	var item = check_item(item_name, quantity)

	for i in range(_items.size()):
		var inventory_item = _items[i]
		
		if inventory_item.item_reference.name != item_name:
			print('next loop')
			continue
			
		if inventory_item.quantity + quantity > item.max_stack_size:
			print("max stack reached; discarding")
			return
		else: 
			inventory_item.quantity += quantity
			quantity = 0
			
		if i == current_selected_item:
			var updated_selected_item = get_item(current_selected_item)
			emit_signal("selected_item_quantity_updated", updated_selected_item)
	
	if quantity > 0:
		var new_item = {
			item_reference = item,
			quantity = 1
		}
		_items.append(new_item)
		quantity = 0
	
#func remove_item(item_name, quantity):
#	print('removing item')
#	var item = check_item(item_name, quantity)
#	var remaining_quantity = quantity
#	if item.stackable:
#		for i in range(_items.size()):
#			if remaining_quantity == 0:
#				break
#			var inventory_item = _items[i]
#			if inventory_item.item_reference.name != item.name:
#				continue
#
#			if inventory_item.quantity < remaining_quantity:
#				print('no items left. breaking')
#				break
#			else:
#				inventory_item.quantity -= remaining_quantity
#
#	var updated_selected_item = get_item(current_selected_item)
#	emit_signal("selected_item_updated", updated_selected_item)
#
#func add_item(item_name, quantity):
#	var item = check_item(item_name, quantity)
#
#	var remaining_quantity = quantity
#	var max_stack_size = item.max_stack_size if item.stackable else 1
#
#	if item.stackable:
#		for i in range(_items.size()):
#			if remaining_quantity == 0:
#				# if we don't have any more items to add, break straight out
#				break
#
#			# creating a reference to the current loop's item index
#			var inventory_item = _items[i]
#
#			# goes to next loop if it is not the item we're concerned with
#			if inventory_item.item_reference.name != item.name:
#				continue
#
#			if i == current_selected_item:
#				var updated_selected_item = get_item(current_selected_item)
#				emit_signal("selected_item_updated", updated_selected_item)
#
#			# create a reference to the inventory_item's current quantity, original_quantity
#			# sets the quantity of the inventory_item to whichever is smaller:
#			# the original_quantity + remaining_quantity...
#			# OR the item's max_stack_size.
#			# subtracts from remaining_quantity the difference between
#			# the item's old and new quantites
#			if inventory_item.quantity < max_stack_size:
#				var original_quantity = inventory_item.quantity
#				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
#				# remaining_quantity -= inventory_item.quantity - original_quantity
#				remaining_quantity = 0
#				prints("max stack size reached. discarding " + item_name + " x" + str(remaining_quantity))
#
#	# while there are items remaining, create a new stack
#	# chooses the lowest value between remaining_quanity & max_stack_size
#	# applies this value to the new_item and appends it to the _items Array
#	# then subtracts the value (new_item.quantity) from remaining_quantity
#	while remaining_quantity > 0:
#		var new_item = {
#			item_reference = item,
#			quantity = min(remaining_quantity, max_stack_size)
#		}
#		_items.append(new_item)
#		remaining_quantity -= new_item.quantity
#
#	emit_signal("inventory_changed", self)
