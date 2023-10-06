extends Control

signal return_lobby
signal switch_debug
signal block_game
signal reset_game
signal load_level

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
@onready var label: RichTextLabel = $Sir/Content/Box/Label
@onready var sound: AudioStreamPlayer2D = $Sir/Sound
func noop():
	pass
func append():
	label.append_text(param())
func delay():
	user_skipped = false
	sum = -float(param())
func user_confirm():
	wait_user = true
	pass
	
func debug():
	switch_debug.emit(int(param()))
func pause():
	var paused: bool = int(param())
	block_game.emit(paused)
	$Blocker.visible = paused

func reset_map():
	reset_game.emit()
	$LoseEffect/Image.custom_minimum_size = Vector2()
func change_level():
	var level_idx: String = param();
	var transition = preload("res://scenes/transition/transition.tscn").instantiate()
	transition.timeout.connect(func(): load_level.emit(int(level_idx)))
	add_child(transition)

func speaker_a():
	$No_54/Content/Box.visible = false
	label = $Sir/Content/Box/Label
	label.clear()

	sound = $Sir/Sound
func speaker_b():
	$No_54/Content/Box.visible = true
	label = $No_54/Content/Box/Label
	label.clear()
	
	sound = $No_54/Sound
	pass
func change_face():
	$Sir/Content/Wrap/Face.SetFace(int(param()))

func win_effect():
	$WinSound.play()
func lose_effect():
	$LoseSound.play()
	create_tween().tween_property($LoseEffect/Image,"custom_minimum_size", Vector2(4000,4000), 1).set_ease(Tween.EASE_OUT)
func finish_game():
	return_lobby.emit(true)
#end dialog scripts
func exit_game():
	return_lobby.emit(false)
func show_menu(visible: bool):
	block_game.emit(visible)
	$Menu.visible = visible
func show_tutorial(visible: bool):
	$Menu.visible = !visible
	$Tutorial.visible = visible
	
func ProcessDialog(delta:float = 0):
	if wait_user:
		return
	sum += delta
	if sum <= 0:
		return
			
	if tokens.size() == 0 || cur_idx >= tokens.size():
		return
		
	var cur_str:String = tokens[cur_idx]
	if cur_offset < cur_str.length():
		if !sound.playing: sound.play(0.05)
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
	if event is InputEventKey && event.pressed:
		match(event.keycode):
			KEY_Z:
				wait_user = false
				user_skipped = false
			KEY_X:
				user_skipped = true

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
