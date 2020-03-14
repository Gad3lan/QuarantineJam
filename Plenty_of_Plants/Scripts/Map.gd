extends Node2D

var allTiles : Array
export var tileCountA : int = 30 # sur le vecteur (1,1)
export var tileCountB : int = 30 # sur le vecteur (-1,1)
export var firstTilePos = Vector2(-175.0,-85)


var tilesWithBuilding : Array
var tilesWithPlants : Array


export var tileSpacing = Vector2(180.0,90.0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func tilePositionToIndexes(pos):
	var arrayPosition = Vector2(0,0)
	arrayPosition.x = floor((pos.x - firstTilePos.x)/(tileSpacing.x))
	arrayPosition.y = floor((pos.y - firstTilePos.y)/(tileSpacing.y))
	return Vector2((arrayPosition.x+arrayPosition.y)*0.5, (-arrayPosition.x+arrayPosition.y)*0.5)

func initTiles():
	var rowB : Array = []
	for b in range(tileCountA):
		rowB = []
		for a in range(tileCountB):
			rowB.push_back(null)
		allTiles.push_back(rowB.duplicate())
		rowB.empty()
	for tile in get_tree().get_nodes_in_group("Tiles"):
		var arrayPosition = Vector2(0,0)
		arrayPosition.x = floor((tile.position.x - firstTilePos.x)/(tileSpacing.x))
		arrayPosition.y = floor((tile.position.y - firstTilePos.y)/(tileSpacing.y))
		#on passe dans un repère basé sur la taille des losanges
		allTiles[(arrayPosition.x+arrayPosition.y)*0.5][(-arrayPosition.x+arrayPosition.y)*0.5] = tile
		#on tourne de 45 degrees
# Called when the node enters the scene tree for the first time.
func tests():
	for row in allTiles:
		for tile in row:
			var indexArray = tilePositionToIndexes(tile.position)
			assert(tile == allTiles[indexArray.x][indexArray.y])

func _ready():
	initTiles()
	tests()
	pass # Replace with function body.

func neighbors(center):
	
	pass

func can_place_on(this):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
