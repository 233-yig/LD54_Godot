extends Control
func _ready():
	pass
	
signal block_game
signal reset_game

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
var label: Label
var icon: TextureRect
func speaker_a():
	icon = $Sir/Icon
	label = $Sir/TextureRect/Label
	label.text = ""
func speaker_b():
	icon = $No_54/Icon
	label = $No_54/TextureRect/Label
	label.text = ""
func pause():
	block_game.emit(true)
func unpause():
	block_game.emit(false)
func init_level():
	var level_idx: String = param();
	var transition = preload("res://scenes/transition/transition.tscn").instantiate()
	transition.timed_out.connect(func(): reset_game.emit(int(level_idx)))
	add_child(transition)
func change_face():
	pass
	
func ProcessDialog():
	if cur_idx >= tokens.size():
		return
	var cur_str:String = tokens[cur_idx]
	label.text += cur_str[cur_offset]
	cur_offset += 1
	if cur_offset >= cur_str.length():
		action()
		cur_offset = 0
		cur_idx += 1
#end dialog scripts

	
var sum:float = 0
func _process(delta):
	if tokens.size() == 0:
		return
	sum += delta
	if sum < 0.1:
		return
	sum = 0
	ProcessDialog()



func SetDialog(content: String):
	tokens = content.split("@", false)
	cur_idx = 0
	cur_offset = 0
func SetData(cur_mines: int, max_mines: int, cur_flips: int, max_flips: int):
	$Status/Mines/Label.text = "%d / %d" % [cur_mines, max_mines]
	$Status/Flips/Label.text = "%d / %d" % [cur_flips, max_flips]
