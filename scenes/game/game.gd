extends Control
@export var levels: Array[LevelData]

var cur_level: LevelData
func InitializeLevel(idx: int):
	if idx < 0 || idx >= levels.size():
		add_sibling(preload("res://scenes/entry/lobby.tscn").instantiate())
		queue_free()
		return
	cur_level = levels[idx]
	
	$GameUI.SetData($MainGame/GameBoard.flag_count(), cur_level.mineCount, $MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	$GameUI.SetDialog(cur_level.start_dialog)
	$MainGame.custom_minimum_size = Vector2(cur_level.mapSize) * $MainGame/Background.texture.get_size() / 3
	$MainGame/GameBoard.load_data(cur_level.mapSize, cur_level.mineCount, cur_level.maxFlips, cur_level.mapStr)
func flip(pos: Vector2i):
	var ret = $MainGame/GameBoard.flip(pos)
	$GameUI.SetData($MainGame/GameBoard.flag_count(), cur_level.mineCount, $MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	if ret == $MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetDialog(cur_level.lose_dialog)
func flag(pos: Vector2i):
	var ret = $MainGame/GameBoard.flag(pos);
	$GameUI.SetData($MainGame/GameBoard.flag_count(), cur_level.mineCount, $MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	if ret == $MainGame/GameBoard.OpResult_Win:
		$GameUI.SetDialog(cur_level.win_dialog)
	elif ret == $MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetDialog(cur_level.lose_dialog)

var interactable: bool = true
func _ready():
	$GameUI.switch_debug.connect(func(open: bool): $MainGame/GameBoard.debug(open))
	$GameUI.block_game.connect(func(pause: bool): interactable = !pause)
	$GameUI.reset_game.connect(InitializeLevel)
	$GameUI.set_board.connect(func(map:String): $MainGame/GameBoard.load_data(cur_level.mapSize, cur_level.mineCount, cur_level.maxFlips, map))

	InitializeLevel(0)

var sum: float
func _process(delta):
	sum += delta
	var mouse_pos: Vector2 = $MainGame.get_local_mouse_position()
	
	$MainGame/Cursor.position = -$MainGame/Cursor.pivot_offset + Vector2(0, 10 * sin(sum)) + mouse_pos.clamp(Vector2(0,0) ,$MainGame.custom_minimum_size)
	if !Rect2(Vector2(0, 0), $MainGame.custom_minimum_size).has_point(mouse_pos):
		return
	if !interactable:
		return
	
	var pos: Vector2 = mouse_pos / ($MainGame/Background.texture.get_size() / 3)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		flip(pos)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		flag(pos)
	else:
		return
