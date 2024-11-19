extends Resource
class_name BookData

enum Condition {
	EXCELLENT,
	GOOD,
	USED,
	DAMAGED,
}

enum Category {
	SCIENCE,
	POLITICS,
	LITERATURE,
}

@export var title: String
@export var author: String
@export var year_of_publication: int
@export var in_collection: bool
@export var return_date: int
@export var condition: Condition
@export var category: Category
@export var tags: Array[String]
@export var color: Color
