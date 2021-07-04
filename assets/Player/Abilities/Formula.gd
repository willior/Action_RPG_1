extends Node2D
class_name Formula

func start(player, formula_used):
	var ingredients_needed = formula_used.formula_reference.cost.keys()
	var quantity_needed = formula_used.formula_reference.cost.values()
	for i in range(0,2):
		player.pouch.remove_ingredient(ingredients_needed[i], quantity_needed[i])
	player.state = 9
	player.animationTree.active = false
	player.animationPlayer.play("Cast_1")
	$AnimationPlayer.play("Ability")
