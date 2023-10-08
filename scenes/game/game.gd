extends Control
@export var levels: Array[LevelData]

var cur_level: LevelData
func StartLevel():
	$Center/MainGame.custom_minimum_size = Vector2(cur_level.mapSize) * $Center/MainGame.texture.get_size() / 3
	var map_scale: int = 5.0 / max(cur_level.mapSize.x, cur_level.mapSize.y)
	if map_scale < 1: $Center.scale = Vector2(map_scale, map_scale)
	$Center/MainGame/GameBoard.load_data(cur_level.mapSize, cur_level.mineCount, cur_level.maxFlips, cur_level.mapStr)
	$GameUI.SetData($Center/MainGame/GameBoard.flag_count(), cur_level.mineCount, $Center/MainGame/GameBoard.flip_count(), cur_level.maxFlips)
func InitializeLevel(idx: int):
	cur_level = levels[idx]
	StartLevel()
	$GameUI.SetDialog(cur_level.start_dialog)
func InitializeSandbox(level: LevelData, debug_on: bool):
	$Center/MainGame/GameBoard.debug(debug_on)
	cur_level = level
	StartLevel()
	$GameUI.SetDialog(cur_level.start_dialog)

func Flip(ret):
	$GameUI.SetData($Center/MainGame/GameBoard.flag_count(), cur_level.mineCount, $Center/MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	if ret == $Center/MainGame/GameBoard.OpResult_Success:
		$FlipSound.play()	
	elif ret == $Center/MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetFailPos()
		$GameUI.SetDialog(cur_level.lose_dialog)

func Flag(ret):
	$GameUI.SetData($Center/MainGame/GameBoard.flag_count(), cur_level.mineCount, $Center/MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	if ret == $Center/MainGame/GameBoard.OpResult_Success:
		$FlagSound.play()
	elif ret == $Center/MainGame/GameBoard.OpResult_Win:
		$FlagSound.play()
		$GameUI.SetDialog(cur_level.win_dialog)
	elif ret == $Center/MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetFailPos()
		$GameUI.SetDialog(cur_level.lose_dialog)
	
func _ready():
	$GameUI.return_lobby.connect(func(win):
		if win: add_sibling(preload("res://scenes/transition/fin_game.tscn").instantiate())
		add_sibling(preload("res://scenes/entry/lobby.tscn").instantiate())
		queue_free()
	)
	$GameUI.switch_debug.connect(func(open: bool): 
		$Center/MainGame/GameBoard.debug(open)
	)
	$GameUI.load_level.connect(InitializeLevel)
	$GameUI.reset_game.connect(StartLevel)
	$Center/MainGame.on_flip.connect(Flip)
	$Center/MainGame.on_flag.connect(Flag)
	$Center/MainGame.on_revert.connect(Flip)
	request_ready()
