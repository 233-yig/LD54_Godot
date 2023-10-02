extends Control



@export var tile: Texture2D
var mapSize: Vector2i
func Start(param):
	mapSize = param.mapSize;
	self.custom_minimum_size = Vector2(mapSize.x - 1, mapSize.y - 1) * tile.get_size()
	$GameBoard.load_data(
		param.mapSize,
		param.mineCount,
		param.maxFlips,
		param.mapStr
	);

func _input(event: InputEvent):
	if !(event is InputEventMouse):
		return
	#var mousePos: Vector2 = self.get_local_mouse_position();
	var pos: Vector2i = self.get_local_mouse_position() / tile.get_size() + Vector2(0.5,0.5)
	if pos.x < 0 || pos.x >= mapSize.x || pos.y < 0 || pos.y >= mapSize.y:
		return
	$Cursor.position = (Vector2(pos) - Vector2(0.5,0.5)) * tile.get_size();
	if !(event is InputEventMouseButton):
		return
	var ret;
	match(event.button_index):
		MOUSE_BUTTON_LEFT:
			ret = $GameBoard.flip(pos);
		MOUSE_BUTTON_RIGHT:
			ret = $GameBoard.flag(pos);
	pass
