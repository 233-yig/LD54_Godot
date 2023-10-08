extends NinePatchRect


signal on_flip
signal on_flag
signal on_revert
func _gui_input(event: InputEvent):
	var mouse_pos: Vector2 = get_local_mouse_position()
	if !Rect2(Vector2(0, 0), custom_minimum_size).has_point(mouse_pos):
		return
	if !event is InputEventMouseButton:
		return
	$ClickEffect.position = mouse_pos - $ClickEffect.pivot_offset
	$ClickEffect.visible = event.pressed
	if event.pressed:
		return
	var pos: Vector2 = mouse_pos / (texture.get_size() / 3)
	match(event.button_index):
		MOUSE_BUTTON_LEFT:
			var ret: int = $GameBoard.revert(pos)
			if ret != $GameBoard.OpResult_Invalid:
				on_revert.emit(ret)
			else:
				on_flip.emit($GameBoard.flip(pos))			
		MOUSE_BUTTON_RIGHT:
			on_flag.emit($GameBoard.flag(pos))



