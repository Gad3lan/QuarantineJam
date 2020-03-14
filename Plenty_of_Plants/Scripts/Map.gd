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



func initTiles():
	var rowB : Array = []
	var idx = 0
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
		for rows in allTiles:
			for t in rows:
				if t == tile:
					print("error, already exists")
					print(arrayPosition.x,", ",arrayPosition.y)
					break
				
		allTiles[(arrayPosition.x+arrayPosition.y)*0.5][(-arrayPosition.x+arrayPosition.y)*0.5] = tile
		#on tourne de 45 degrees
	print(allTiles)
	assert(allTiles.size() == tileCountA)
	assert(allTiles[-1].size() == tileCountB)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	initTiles()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
