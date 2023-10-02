extends Control
@export var levels: Array[Resource]
var current :int = 0

var scene: PackedScene = preload("res://scenes/main_game.tscn");
func _process(delta):
	self.custom_minimum_size = get_viewport_rect().size
func Resume():
	$ui.visible = true

func NextLevel():
	var game:Node = scene.instantiate()
	self.add_child(game)
	game.Start(levels[current])
	game.tree_exited.connect(self.Resume)
	$ui.visible = false
	current += 1
