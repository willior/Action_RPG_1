extends "res://assets/Player/Stats/PlayerStats.gd"

func save():
	var player1_stats = {
		"vitality": vitality,
		"health": health,
		"max_health": max_health,
		"endurance": endurance,
		"stamina": stamina,
		"max_stamina": max_stamina,
		"defense": defense,
		"strength": strength,
		"dexterity": dexterity,
		"speed": speed,
		"magic": magic,
		"level": level,
		"experience": experience,
		"experience_required": experience_required,
		"experience_total": experience_total,
		"weapon_level": weapon_level,
		"weapon_xp": weapon_xp,
		"weapon_xp_required": weapon_xp_required,
		"weapon_xp_total": weapon_xp_total,
	}
	var save_dict = {
		"player1_stats": player1_stats
	}
	return save_dict
