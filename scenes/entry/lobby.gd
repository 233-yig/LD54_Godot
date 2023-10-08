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
	custom.mapSize.x = $Form/SandboxInfo/Main/Values/MapSize/x.value
	custom.mapSize.y = $Form/SandboxInfo/Main/Values/MapSize/y.value
	custom.maxFlips = $Form/SandboxInfo/Main/Values/Flips.value
	custom.mineCount = $Form/SandboxInfo/Main/Values/Mines.value
	custom.mapStr = "e".repeat(custom.mapSize.x * custom.mapSize.y)
	game.InitializeSandbox(custom, $Form/SandboxInfo/Debug.button_pressed)
	add_sibling(game)
	queue_free()


func show_menu():
	pass # Replace with function body.
