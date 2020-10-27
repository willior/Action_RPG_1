extends Resource
class_name ItemResource

export var name:  String
export var stackable : bool = false
export var max_stack_size : int = 1

enum itemType { CONSUMABLE, TOOL, EQUIPMENT, QUEST }
export(itemType) var type
export var texture : Texture
