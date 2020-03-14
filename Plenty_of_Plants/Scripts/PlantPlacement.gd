extends Area2D

export (int) var xTilesNumber
export (int) var yTilesNumber
#export (NodePath) var plantPath
var tileSize = Vector2()
var viewportSize = Vector2()
var plant

func _ready():
	tileSize = Vector2(get_viewport().size.x / xTilesNumber, get_viewport().size.y / yTilesNumber)
	viewportSize = get_viewport().size
	#plant = get_node(plantPath)

func _process(delta):
	var mousePos = get_viewport().get_mouse_position() - viewportSize/2
	var xTile = round(mousePos.x / tileSize.x)
	var yTile = round(mousePos.y / tileSize.y)
	if(int(abs(yTile))%2 == 1):
		xTile += 0.50
	var pos = Vector2(xTile, yTile) * tileSize + viewportSize/2
	#print(xTile, " ", yTile)
	set_position(pos)
