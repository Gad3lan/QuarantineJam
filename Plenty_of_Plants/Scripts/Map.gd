extends Node2D

var allTiles : Array
export var tileCountA : int = 30 # sur le vecteur (1,1)
export var tileCountB : int = 30 # sur le vecteur (-1,1)
export var firstTilePos = Vector2(-175.0,-85)


var tilesWithBuilding : Array
var tilesWithPlants : Array


export var tileSpacing = Vector2(180.0,90.0)

onready var pollen = preload("res://Scenes/BioMasse.tscn")

enum BuildingType {NONE, PARCKING, USINE, HOTEL, ROAD}
enum PlantType {NONE, CHAMPIGNON, LIERE, EUCALYPTUS, SECOIA, RONCE}

var plantCost ={
	PlantType.CHAMPIGNON : 3,
	PlantType.LIERE : 3,
	PlantType.RONCE : 4,
	PlantType.EUCALYPTUS : 9,
	PlantType.SECOIA : 6,
	PlantType.NONE : 0
}

export var biomasseNow : int = 10
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
			var neighbors = neighborsIndexes(indexArray)
			for neighIndexes in neighbors:
				assert(checkInBounds(neighIndexes))

func checkInBounds(vectorIndex):
	return  vectorIndex.x >= 0 && vectorIndex.y >= 0 && vectorIndex.x < tileCountA && vectorIndex.y < tileCountB

func _ready():
	initTiles()
	tests()
	spawnPollen(Vector2(0,0))
	spawnPollen(Vector2(2,2))
	spawnPollen(Vector2(tileCountA-1,tileCountB-1))
	pass # Replace with function body.

func neighborsIndexes(centerPos):
	var otherPos:Array = []
	if centerPos.x >0:
		if centerPos.y >0:
			otherPos.push_back(Vector2(centerPos.x - 1, centerPos.y - 1))
		otherPos.push_back(Vector2(centerPos.x-1,centerPos.y))
		if centerPos.y < tileCountB - 1:
			otherPos.push_back(Vector2(centerPos.x - 1, centerPos.y + 1))
	if centerPos.x < tileCountA - 1:
		if centerPos.y >0:
			otherPos.push_back(Vector2(centerPos.x + 1, centerPos.y - 1))
		otherPos.push_back(Vector2(centerPos.x+1,centerPos.y))
		if centerPos.y < tileCountB - 1:
			otherPos.push_back(Vector2(centerPos.x + 1, centerPos.y + 1))
	if centerPos.y < tileCountB - 1:
		otherPos.push_back(Vector2(centerPos.x, centerPos.y +1))
	if centerPos.y > 0:
		otherPos.push_back(Vector2(centerPos.x, centerPos.y - 1))
	return otherPos

func hasNeighbors(thisTile):
	var neighs = neighborsIndexes(thisTile.pos)
	var canPlace = false
	for neighPos in neighs:
		canPlace = allTiles[neighPos.y][neighPos.x].hasPlant()
		if canPlace:
			break
	return canPlace
	pass



func buy(toPlant):
	var canPlant = biomasseNow > plantCost[toPlant]
	biomasseNow -= plantCost[toPlant] if canPlant else 0
	return canPlant
		

func can_place(toPlant,thisTile):
	return (true||hasNeighbors(thisTile))  && buy(toPlant)



func spawnPollen(tileIndex):
	if (not checkInBounds(tileIndex)):
		print("Warning, tile not in bound : ",tileIndex," bounds =",tileCountA,tileCountB)
		return
	var pollenInstance = pollen.instance()
	pollenInstance.position = allTiles[tileIndex.x][tileIndex.y].position
	call_deferred("add_child",pollenInstance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
