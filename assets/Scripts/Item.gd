extends Resource
class_name ItemResource
# Item

export var name : String
export var stackable : bool = false
export var max_stack_size : int = 1

enum itemType { CONSUMABLE, TOOL, QUEST }
export(itemType) var type
export var texture : Texture

export var healing : int = 2
