extends Control
@export var levels: Array[Resource]
var current :int = 0

var scene: PackedScene = preload("res://scenes/main_game.tscn");
func Resume():
	$ui.visible = true

func NextLevel():
	var game:Node = scene.instantiate()
	game.Start(levels[current])
	add_child(game)
	game.tree_exited.connect(self.Resume)
	$ui.visible = false
	current += 1
