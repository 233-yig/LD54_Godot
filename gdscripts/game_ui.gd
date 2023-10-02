extends Control


func UpdateData(cur_mines: int, max_mines: int, cur_flips: int, max_flips: int):
	$Status/Mines/Label.text = "%d / %d" % [cur_mines, max_mines]
	$Status/Flips/Label.text = "%d / %d" % [cur_flips, max_flips]



func action(op: String):
	pass

var texts: PackedStringArray;
var cur_idx: int = 0
var cur_offset: int = 0

func UpdateDialog(content: String):
	texts = content.split("@")
	cur_idx = 0
	cur_offset = 0

var buf:float = 0
func _process(delta):
	if texts.size() == 0 :
		return
	buf += delta
	if buf < 0.1:
		return
	buf = 0
	var cur_str:String = texts[cur_idx]
	$Dialog/Label.text += cur_str[cur_offset]
	cur_offset += 1
	if cur_offset == cur_str.length():
		action(texts[cur_idx+1])
		cur_idx += 2;
		cur_offset = 0
