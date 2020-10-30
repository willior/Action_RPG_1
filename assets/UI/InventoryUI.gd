extends GridContainer

onready var sprite = $Sprite
onready var label = $Label

func _init():
	# warning-ignore:return_value_discarded
	GameManager.connect("player_initialized", self, "_on_player_initialized")
# warning-ignore:return_value_discarded
	GameManager.connect("player_reinitialized", self, "_on_player_initialized")
	
func _on_player_initialized(player):
	player.inventory.connect("selected_item_quantity_updated", self, "_on_selected_item_quantity_updated")
	player.inventory.connect("current_selected_item_changed", self, "_on_current_selected_item_changed")
	
	

func _on_selected_item_quantity_updated(updated_selected_item):
	label.text = "%s x%d" % [updated_selected_item.item_reference.name, updated_selected_item.quantity]
	sprite.texture = updated_selected_item.item_reference.texture


func _on_current_selected_item_changed(new_selected_item):
	label.text = "%s x%d" % [new_selected_item.item_reference.name, new_selected_item.quantity]
	sprite.texture = new_selected_item.item_reference.texture
