extends NinePatchRect


signal game_op
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
			game_op.emit($GameBoard.flip(pos))
		MOUSE_BUTTON_RIGHT:
			game_op.emit($GameBoard.flag(pos))



