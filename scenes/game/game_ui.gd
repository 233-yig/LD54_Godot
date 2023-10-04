extends Control
func _ready():
	pass
	
signal switch_debug
signal block_game
signal reset_game
signal set_board

var tokens: PackedStringArray;
var cur_idx: int = 0
var cur_offset: int = 0

func param():
	cur_idx += 1
	return tokens[cur_idx]
func action():
	cur_idx += 1
	if cur_idx >= tokens.size():
		return
	call(tokens[cur_idx])

#begin dialog scripts
var wait_user: bool = false
var user_skipped: bool = false
@onready var label: RichTextLabel = $Sir/Box/Label

func noop():
	pass
func append():
	label.append_text(param())
func delay():
	user_skipped = false
	sum -= float(param())
func user_confirm():
	user_skipped = false
	wait_user = true
	pass
	
func debug():
	switch_debug.emit(int(param()))
func pause():
	block_game.emit(int(param()))
func set_map():
	set_board.emit(param())
func change_level():
	var level_idx: String = param();
	var transition = preload("res://scenes/transition/transition.tscn").instantiate()
	transition.timeout.connect(func(): reset_game.emit(int(level_idx)))
	add_child(transition)

func speaker_a():
	$No_54/Box.visible = false
	label = $Sir/Box/Label
	label.clear()
	pass
func speaker_b():
	$No_54/Box.visible = true
	label = $No_54/Box/Label
	label.clear()
	label.append_text("[center][/center]")
	pass
func change_face():
	$Sir/Face.SetFace(int(param()))

func win_effect():
	pass
func lose_effect():
	pass

#end dialog scripts
func ProcessDialog(delta:float = 0):
	if wait_user:
		return
	if !user_skipped:
		sum += delta
		if sum <= 0:
			return
		sum -= 0.05
			
	if tokens.size() == 0 || cur_idx >= tokens.size():
		return
		
	var cur_str:String = tokens[cur_idx]
	if cur_offset < cur_str.length():
		if user_skipped:
			label.add_text(cur_str.substr(cur_offset))
			cur_offset = cur_str.length()
		else:
			label.add_text(cur_str[cur_offset])
			cur_offset += 1
	else:
		action()
		cur_offset = 0
		cur_idx += 1
	
	if user_skipped:
		ProcessDialog()	

func _input(event: InputEvent):
	if event is InputEventKey && event.pressed == false:
		if event.keycode == KEY_Z:
			wait_user = false
		if event.keycode == KEY_X:
			user_skipped = true
	elif event is InputEventMouseButton:
		wait_user = false
var sum: float = 0
func _process(delta):
	ProcessDialog(delta)


func SetDialog(content: String):
	tokens = content.split("@")
	for i in range(tokens.size()):
		tokens[i] = tokens[i].strip_edges()
	cur_idx = 0
	cur_offset = 0
func SetData(cur_mines: int, max_mines: int, cur_flips: int, max_flips: int):
	$Status/Mines/Label.text = "%d / %d" % [cur_mines, max_mines]
	$Status/Flips/Label.text = "%d / %d" % [cur_flips, max_flips]
