extends Resource
@export var width: int
@export var height: int
@export var mines: int
@export var map: String

func _init(p_width = 0, p_height = 0, p_mines = 0, p_map = ""):
	width = p_width
	height = p_height
	mines = p_mines
	map = p_map
