extends HBoxContainer

func _on_Buffs_sort_children():
	if get_child_count() == 0:
		hide()
	else:
		show()