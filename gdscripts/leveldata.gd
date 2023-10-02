extends Resource
@export var mapSize: Vector2i
@export var mineCount: int
@export var maxFlips: int
@export var mapStr: String

func _init():
	mapSize = Vector2i()
	mineCount = 0
	maxFlips = 0
	mapStr = ""
