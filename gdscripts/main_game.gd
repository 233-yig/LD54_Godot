extends Control

@export var tile: Texture2D
var mapSize: Vector2i
func Start(param):
	mapSize = param.mapSize;
	$MainGame.custom_minimum_size = Vector2(mapSize.x, mapSize.y) * tile.get_size()
	$MainGame/GameBoard.load_data(
		param.mapSize,
		param.mineCount,
		param.maxFlips,
		param.mapStr
	);

func _input(event: InputEvent):
	if !(event is InputEventMouse):
		return
	#var mousePos: Vector2 = self.get_local_mouse_position();
	var pos: Vector2i = $MainGame.get_local_mouse_position() / tile.get_size() * $MainGame.scale
	print(pos)
	if pos.x < 0 || pos.x >= mapSize.x || pos.y < 0 || pos.y >= mapSize.y:
		return
	$MainGame/Cursor.position = $MainGame.get_local_mouse_position() - tile.get_size() * $MainGame/Cursor.scale;
	if !(event is InputEventMouseButton):
		return
	var ret;
	match(event.button_index):
		MOUSE_BUTTON_LEFT:
			ret = $MainGame/GameBoard.flip(pos);
		MOUSE_BUTTON_RIGHT:
			ret = $MainGame/GameBoard.flag(pos);
	pass
