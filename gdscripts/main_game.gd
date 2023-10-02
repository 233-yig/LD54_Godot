extends Control


var pos: Vector2i
var mapSize: Vector2i
func Start(param):
	pos = param.startPos
	mapSize = param.mapSize
	$Background/GameBoard.load_data(
		param.mapSize,
		param.mineCount,
		param.maxFlips,
		param.mapStr
	);

func _unhandled_input(event):
	if !(event is InputEventKey):
		return
	if !event.pressed:
		return
	match(event.keycode):
		KEY_LEFT:
			if pos.x > 0 :
				pos.x -= 1
		KEY_RIGHT:
			if pos.x < mapSize.x - 1 :
				pos.x += 1
		KEY_UP:
			if pos.y > 0 :
				pos.y -= 1
		KEY_DOWN:
			if pos.y < mapSize.y - 1 :
				pos.y += 1
		KEY_Z:
			$Background/GameBoard.flip(pos);
		KEY_X:
			$Background/GameBoard.flag(pos);
	var size:Vector2 = $Background/Cursor.texture.get_size()
	$Background/Cursor.position = Vector2(pos.x * size.x, pos.y * size.y)
