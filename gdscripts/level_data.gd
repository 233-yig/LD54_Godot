class_name LevelData extends Resource
@export var mapSize: Vector2i
@export var mineCount: int
@export var maxFlips: int
@export_multiline var start_dialog: String
@export_multiline var lose_dialog: String
@export_multiline var win_dialog: String
@export_multiline var mapStr: String
func _init():
	mapSize = Vector2i()
	mineCount = 0
	maxFlips = 0
	mapStr = ""
	win_dialog = ""
	lose_dialog = ""
	start_dialog = ""
