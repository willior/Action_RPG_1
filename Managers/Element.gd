extends Node

# 0 : normal
# 1 : fire
# 2 : ice
# 3 : lightning
# 4 : water
# 5 : wind
# 6 : earth
# 7 : light
# 8 : dark
# 9 : verve
# 10 : entropy

enum {
	NORMAL, 	# 0
	FIRE, 		# 1
	ICE,		# 2
	LIGHTNING,	# 3
	WATER,		# 4
	WIND,		# 5
	EARTH,		# 6
	LIGHT,		# 7
	DARK,		# 8
	VERVE,		# 9
	ENTROPY		# 10
}

var NoMod = [1,1,1,1,1,1,1,1,1,1,1]
var FireMod = [1, 0.5, 1.5, 1, 1, 1, 1, 1, 1, 1, 1]
var IceMod = [1, 1.5, 0.5, 1, 1, 1, 1, 1, 1, 1, 1]
var LightningMod = [1, 1, 1, 0.5, 1.5, 1, 1, 1, 1, 1, 1]
var WaterMod = [1, 1.5, 0.5, 1.5, 0.5, 1, 1, 1, 1, 1, 1]
var WindMod = [1, 1, 1, 1, 1, 1.5, 1, 1, 1, 1, 1]
var EarthMod = [1, 1, 1, 1.5, 1, 0.5, 0.5, 1, 1, 1, 1]
var LightMod = [1, 1, 1, 1, 1, 1, 1, 0.5, 1.5, 1, 1]
var DarkMod = [1, 1, 1, 1, 1, 1, 1, 1.5, 0.5, 1, 1, ]
var VerveMod = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1]
var EntropyMod = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1.5, -1]

func calculate_element_ratio(source_element=0, target_element=0):
	var elementRatio = Array()
	match source_element:
		0: elementRatio = NoMod
		1: elementRatio = FireMod
		2: elementRatio = IceMod
		3: elementRatio = LightningMod
		4: elementRatio = WaterMod
		5: elementRatio = WindMod
		6: elementRatio = EarthMod
		7: elementRatio = LightMod
		8: elementRatio = DarkMod
		9: elementRatio = VerveMod
		10: elementRatio = EntropyMod
	# print(source_element, " vs ", target_element, " = ", elementRatio[target_element])
	return elementRatio[target_element]
