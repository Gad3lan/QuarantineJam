extends Node

export (int) var xTilesNumber = 21
export (int) var yTilesNumber = 21
var tileSize = Vector2()

func _ready():
	tileSize = Vector2(get_viewport().size.x / xTilesNumber, get_viewport().size.y / yTilesNumber)

func _process(delta):
	var mousePos = get_viewport().get_mouse_position()
	var xTile = int(round(mousePos.x / tileSize.x))
	var yTile = int(round(mousePos.y / tileSize.y))
	#print(xTile, " ", yTile)
	print(get_viewport().size)
