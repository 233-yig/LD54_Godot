extends Control
@export var levels: Array[LevelData]

var cur_level: LevelData
func StartLevel():
	$MainGame/GameBoard.load_data(cur_level.mapSize, cur_level.mineCount, cur_level.maxFlips, cur_level.mapStr)
	$GameUI.SetData($MainGame/GameBoard.flag_count(), cur_level.mineCount, $MainGame/GameBoard.flip_count(), cur_level.maxFlips)
func InitializeLevel(idx: int):
	if idx < 0 || idx >= levels.size():
		add_sibling(preload("res://scenes/entry/lobby.tscn").instantiate())
		queue_free()
		return
	cur_level = levels[idx]
	$MainGame.custom_minimum_size = Vector2(cur_level.mapSize) * $MainGame/Background.texture.get_size() / 3
	StartLevel()
	$GameUI.SetDialog(cur_level.start_dialog)

func flip(pos: Vector2i):
	var ret = $MainGame/GameBoard.flip(pos)
	$GameUI.SetData($MainGame/GameBoard.flag_count(), cur_level.mineCount, $MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	if ret == $MainGame/GameBoard.OpResult_Success:
		$FlipSound.play()
	if ret == $MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetDialog(cur_level.lose_dialog)
func flag(pos: Vector2i):
	var ret = $MainGame/GameBoard.flag(pos);
	$GameUI.SetData($MainGame/GameBoard.flag_count(), cur_level.mineCount, $MainGame/GameBoard.flip_count(), cur_level.maxFlips)
	if ret == $MainGame/GameBoard.OpResult_Success:
		$FlagSound.play()	
	elif ret == $MainGame/GameBoard.OpResult_Win:
		$FlagSound.play()	
		$GameUI.SetDialog(cur_level.win_dialog)
	elif ret == $MainGame/GameBoard.OpResult_Lose:
		$GameUI.SetDialog(cur_level.lose_dialog)

var interactable: bool = true
func _ready():
	$GameUI.return_lobby.connect(func(win):
		if win:
			add_sibling(preload("res://scenes/transition/fin_game.tscn").instantiate())
		add_sibling(preload("res://scenes/entry/lobby.tscn").instantiate())
		queue_free()
	)
	$GameUI.switch_debug.connect(func(open: bool): 
		$MainGame/GameBoard.debug(open)
	)
	$GameUI.block_game.connect(func(pause: bool): 
		interactable = !pause
	)
	$GameUI.load_level.connect(InitializeLevel)
	$GameUI.reset_game.connect(StartLevel)
	InitializeLevel(0)
	request_ready()
	
func _input(event):
	if !event is InputEventMouseButton:
		return
	$ClickEffect.visible = interactable && Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	$ClickEffect.position = get_global_mouse_position()

	if !interactable:
		return
	if event.pressed:
		return
	var mouse_pos: Vector2 = $MainGame.get_local_mouse_position()
	if !Rect2(Vector2(0, 0), $MainGame.custom_minimum_size).has_point(mouse_pos):
		return
	var pos: Vector2 = $MainGame.get_local_mouse_position() / ($MainGame/Background.texture.get_size() / 3)
	match(event.button_index):
		MOUSE_BUTTON_LEFT:
			flip(pos)
		MOUSE_BUTTON_RIGHT:
			flag(pos)
var sum: float
func _process(delta):
	sum += delta
	$MainGame/Cursor.visible = interactable
	$MainGame/Cursor.position = $MainGame.get_local_mouse_position().clamp(
		Vector2(0,0),
		$MainGame.custom_minimum_size
	) - $MainGame/Cursor.pivot_offset + Vector2(0, 10 * sin(sum)) 
