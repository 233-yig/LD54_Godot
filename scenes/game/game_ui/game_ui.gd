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
@onready var label: Label = $Sir/Box/Label

func noop():
	pass
func set_map():
	set_board.emit(param())
func speaker_a():
	label.text = ""
	$No_54/Box.visible = false
	label = $Sir/Box/Label
	pass
func speaker_b():
	label.text = ""
	$No_54/TextureRect.visible = true
	label = $No_54/TextureRect/Label
	pass
func pause():
	block_game.emit(int(param()))
func debug():
	switch_debug.emit(int(param()))
func change_level():
	var level_idx: String = param();
	var transition = preload("res://scenes/transition/transition.tscn").instantiate()
	transition.timed_out.connect(func(): reset_game.emit(int(level_idx)))
	add_child(transition)
func delay():
	if !user_skipped:
		sum -= float(param())
func change_face():
	$Sir/Face.SetFace(int(param()))
func win_effect():
	#todo 
	pass
func lose_effect():
	#todo
	pass
func user_confirm():
	user_skipped = false
	wait_user = true
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
			$Sir/Box/Label.text += cur_str.substr(cur_offset)
			cur_offset = cur_str.length()
		else:
			$Sir/Box/Label.text += cur_str[cur_offset]
			cur_offset += 1
	else:
		action()
		cur_offset = 0
		cur_idx += 1
	
	if user_skipped:
		ProcessDialog()	
var sum:float = 0
func _process(delta):
	if Input.is_key_pressed(KEY_Z):
		wait_user = false
	if Input.is_key_pressed(KEY_X):
		user_skipped = true
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
