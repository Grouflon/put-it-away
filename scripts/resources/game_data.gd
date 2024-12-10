extends Resource
class_name GameData

@export var days: Array[DayData]
@export var global_rules: Array[GDScript]
@export var global_comments: Array[GDScript]

@export_group("prefabs")
@export var rule_prefab: PackedScene
