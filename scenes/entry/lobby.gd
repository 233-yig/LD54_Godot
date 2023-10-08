extends Control

@export var custom: LevelData
var game: Node = preload("res://scenes/game/game.tscn").instantiate()
func play():
	game.InitializeLevel(0)
	add_sibling(game)
	queue_free()
func sandbox_menu(open: bool):
	$Menu.visible = !open
	$Form.visible = open
func sandbox():
	custom.mapSize = Vector2i(int($Form/SandboxInfo/Main/Values/MapSize/x.text), int($Form/SandboxInfo/Main/Values/MapSize/y.text))
	custom.maxFlips = $Form/SandboxInfo/Main/Values/Flips.text
	custom.mineCount = $Form/SandboxInfo/Main/Values/Mines.text
	custom.mapStr = "e".repeat(custom.mapSize.x * custom.mapSize.y)
	game.InitializeSandbox(custom, $Form/SandboxInfo/Debug.button_pressed)
	add_sibling(game)
	queue_free()


func show_menu():
	pass # Replace with function body.
