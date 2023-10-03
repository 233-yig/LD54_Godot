extends Control
@export var levels: Array[LevelData]

var cur_mines: int
var cur_flips: int
var cur_level: LevelData
func InitializeLevel(idx: int):
	cur_level = levels[idx]
	
	$GameUI.SetData(cur_mines, cur_level.mineCount, cur_flips, cur_level.maxFlips)
	$GameUI.SetDialog(cur_level.start_dialog)
	$MainGame.custom_minimum_size = Vector2(cur_level.mapSize) * $MainGame/Background.texture.get_size() / 3
	$MainGame/GameBoard.load_data(cur_level.mapSize, cur_level.mineCount, cur_level.maxFlips, cur_level.mapStr)

func flip(pos: Vector2i):
	var ret = $MainGame/GameBoard.flip(pos)
	if ret == $MainGame/GameBoard.OpResult_Success && cur_flips < cur_level.maxFlips:
		cur_flips += 1
		$GameUI.SetData(cur_mines, cur_level.mineCount, cur_flips, cur_level.maxFlips)
	elif ret == $MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetDialog(cur_level.lose_dialog)
func flag(pos: Vector2i):
	var ret = $MainGame/GameBoard.flag(pos);
	if ret == $MainGame/GameBoard.OpResult_Success:
		cur_mines += 1
		$GameUI.SetData(cur_mines, cur_level.mineCount, cur_flips, cur_level.maxFlips)
	elif ret == $MainGame/GameBoard.OpResult_Win:
		cur_mines += 1
		$GameUI.SetData(cur_mines, cur_level.mineCount, cur_flips, cur_level.maxFlips)
		$GameUI.SetDialog(cur_level.win_dialog)
	elif ret == $MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetDialog(cur_level.lose_dialog)

var interactable: bool = true
func _ready():
	$GameUI.block_game.connect(func(pause: bool): interactable = !pause)
	$GameUI.reset_game.connect(InitializeLevel)
	InitializeLevel(0)

var sum: float
func _process(delta):
	sum += delta
	var mouse_pos: Vector2 = $MainGame.get_local_mouse_position()
	
	$MainGame/Cursor.position = Vector2(0, 10 * sin(sum)) + mouse_pos.clamp(Vector2(0,0) ,$MainGame.custom_minimum_size) - $MainGame/Cursor.size * $MainGame/Cursor.scale
	if !Rect2(Vector2(0, 0), $MainGame.custom_minimum_size).has_point(mouse_pos):
		return
	if !interactable:
		return
	
	var pos: Vector2 = mouse_pos / ($MainGame/Background.texture.get_size() / 3)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		flip(mouse_pos / ($MainGame/Background.texture.get_size() / 3))
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		flag(mouse_pos / ($MainGame/Background.texture.get_size() / 3))
	else:
		return
