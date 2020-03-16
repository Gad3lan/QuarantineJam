tool
extends Node2D

onready var ui = get_parent().get_node("CameraNode").get_node("CanvasLayer/Ui")

enum BuildingType {NONE, PARCKING, USINE, HOTEL, ROAD0, ROAD1, ROAD2, ROAD3, ROAD4, ROAD5, ROAD6, HLM, IMMEUBLE, IMMEUBLE2, BUILDING, CENTRALE, TERRAIN}
enum PlantType {NONE, CHAMPIGNON, LIERE, TOURNESSOL, EUCALYPTUS, HERBE, SECOIA, MYCELIUM, RONCE, BAMBOU, MOUSSE, ORTIE, CONSOUD}
enum toTransmit {Z_INDEX, B_TYPE}

export var tileCountA : int = 30 # sur le vecteur (1,1)
export var tileCountB : int = 30 # sur le vecteur (-1,1)
export (bool) var assignTiles = false setget initTiles
export (bool) var reset = false setget resetTiles
export (bool) var placeTiles = false setget roundTilesTransform
export (bool) var resetCoords = false setget resetTilesCoord
export var firstTilePos = Vector2(-175.0,-85)
export var tileSpacing = Vector2(180.0,90.0)
export var biomasseNow : int = 500

var allTiles : Array
var tilesWithBuilding : Array
var tilesWithPlants : Array
var plantCost ={
	PlantType.CHAMPIGNON : 3,
	PlantType.LIERE : 4,
	PlantType.RONCE : 5,
	PlantType.EUCALYPTUS : 7,
	PlantType.SECOIA : 6,
	PlantType.HERBE : 3,
	PlantType.RONCE : 3,
	PlantType.MYCELIUM : 4,
	PlantType.CONSOUD : 5,
	PlantType.TOURNESSOL : 5,
	PlantType.NONE : 0
}

var toDoForBuilding ={
	BuildingType.HOTEL : Vector2(2,2),
	BuildingType.PARCKING : Vector2(2,2),
	BuildingType.USINE : Vector2(4,4),
	BuildingType.HLM : Vector2(4,4),
	BuildingType.IMMEUBLE : Vector2(2,2),
	BuildingType.IMMEUBLE2 : Vector2(2,2),
	BuildingType.BUILDING : Vector2(4,4),
	BuildingType.CENTRALE : Vector2(4,4),
	BuildingType.TERRAIN : Vector2(4,4)
}

func tilePositionToIndexes(pos):
	var arrayPosition = Vector2(0,0)
	arrayPosition.x = round((pos.x - firstTilePos.x)/(tileSpacing.x))
	arrayPosition.y = round((pos.y - firstTilePos.y)/(tileSpacing.y))
	return Vector2((arrayPosition.x+arrayPosition.y)*0.5, (-arrayPosition.x+arrayPosition.y)*0.5)

func placeVectorOnGrid(vec,gridDims,gridOffset):
	vec.x = gridOffset.x + round((vec.x-gridOffset.x)/(gridDims.x))*gridDims.x
	vec.y = gridOffset.y + round((vec.y-gridOffset.y)/(gridDims.y))*gridDims.y
	assert(int(vec.x-gridOffset.x)%int(gridDims.x)==0) 
	assert(int(vec.y-gridOffset.y)%int(gridDims.y)==0)
	return vec

func roundTilesTransform(boolean):
	for tile in get_children():
		tile.position = placeVectorOnGrid(tile.position,tileSpacing,firstTilePos)

func resetTiles(boolean):
	if not boolean:
		return
	assignTiles = false
	allTiles = getAllTiles()
	for tile in get_children():
		tile.coordOnTexture = Vector2(0,0)
		tile.root = true
		tile.BType = BuildingType.NONE
		tile.root = false
		reset = false

func resetTilesCoord(boolean):
	if not boolean:
		return
	assignTiles = false
	allTiles = getAllTiles()
	for tile in get_children():
		tile.coordOnTexture = Vector2(0,0)
		resetCoords = false

func getAllTiles():
	var rowB : Array = []
	var tilesToGet = []
	for b in range(tileCountA):
		rowB = []
		for a in range(tileCountB):
			rowB.push_back(null)
		tilesToGet.push_back(rowB.duplicate())
		rowB.empty()
	for tile in get_children():
		var arrayPosition = Vector2(0,0)
		arrayPosition.x = round((tile.position.x - firstTilePos.x)/(tileSpacing.x))
		arrayPosition.y = round((tile.position.y - firstTilePos.y)/(tileSpacing.y))
		#on passe dans un repère basé sur la taille des losanges
		tilesToGet[(arrayPosition.x+arrayPosition.y)*0.5][(-arrayPosition.x+arrayPosition.y)*0.5] = tile
		#on tourne de 45 degrees
		tile.z_index = -2*max(tileCountA,tileCountB)-round(tile.position.y/firstTilePos.y)
		#tile.baseIndex = -2*max(tileCountA,tileCountB)-round(tile.position.y/firstTilePos.y)
	return tilesToGet

func initTiles(hasToInit):	
	allTiles = getAllTiles()
	if not hasToInit:
		return
	hasToInit = false
	assignTiles = false
	propageTypeAndZ()

func getRectIndexFrom(index,sizeA,sizeB):
	var rectIndexes = []
	for a in range(index.x - sizeA+1,index.x+1):
		for b in range(index.y - sizeB+1,index.y+1):
			rectIndexes.push_back(Vector2(a,b))
	return rectIndexes

func propageTypeAndZ():
	for tile in get_children():
		if toDoForBuilding.has(tile.BType) and tile.root:
			var dimensions = toDoForBuilding[tile.BType]
			var indexVec = tilePositionToIndexes(tile.position)
			for indexToTransferTo in getRectIndexFrom(indexVec,dimensions.x,dimensions.y):
				allTiles[indexToTransferTo.x][indexToTransferTo.y].parent = tile
				allTiles[indexToTransferTo.x][indexToTransferTo.y].coordOnTexture = indexVec-indexToTransferTo
				allTiles[indexToTransferTo.x][indexToTransferTo.y].BType2 = tile.BType
				allTiles[indexToTransferTo.x][indexToTransferTo.y].z_index = tile.z_index

func checkInBounds(vectorIndex):
	return  vectorIndex.x >= 0 && vectorIndex.y >= 0 && vectorIndex.x < tileCountA && vectorIndex.y < tileCountB

func _ready():
	ui.setPollen(biomasseNow)
	initTiles(true)
	allTiles[0][-1].instancePlant(PlantType.SECOIA)
	tests()

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

func hasPlantNeighbors(thisTile):
	var neighs = neighborsIndexes(tilePositionToIndexes(thisTile.position))
	var canPlace = false
	for neighPos in neighs:
		canPlace = canPlace || allTiles[neighPos.x][neighPos.y].hasPlant()
		if canPlace:
			if (not thisTile.root):
				thisTile.parent.nbPlantsInTile += thisTile.plantDamage
			return true
	return canPlace

func pickUpPollen():
	biomasseNow += 3
	ui.setPollen(biomasseNow)

func buy(toPlant):
	var canPlant = biomasseNow > plantCost[toPlant]
	biomasseNow -= plantCost[toPlant] if canPlant else 0
	ui.setPollen(biomasseNow)
	return canPlant


func protect(power,tile):
	for neigh in neighborsIndexes(tilePositionToIndexes(tile.position)):
		allTiles[neigh.x][neigh.y].receiveSoutien(power)


func can_place(toPlant,thisTile):
	print("z_index : ",thisTile.baseZIndex)
	return hasPlantNeighbors(thisTile)
	
#A PARTIR DE LA,FONCTIONS DE TEST
#////////////////////////////////////////////////////////////////////////////////////////////////////////
func flourishNeighbors(pos:Vector2):
	for tilePos in neighborsIndexes(pos):
		print(allTiles[tilePos.x][tilePos.y])
		allTiles[tilePos.x][tilePos.y].spawnPollen()

var idxToAddTo = Vector2(0,0)
"""
func _input(event):
	if event is InputEventKey:
		print(idxToAddTo)
		if (idxToAddTo.x == tileCountB):
			idxToAddTo.y += 1
			idxToAddTo.x = 0
		else:
			idxToAddTo.x +=1
		if event.get_scancode_with_modifiers() == KEY_A:
			flourishNeighbors(idxToAddTo)
"""
func tests():
	for row in allTiles:
		for tile in row:
			var indexArray = tilePositionToIndexes(tile.position)
			assert(tile == allTiles[indexArray.x][indexArray.y])
			var neighbors = neighborsIndexes(indexArray)
			for neighIndexes in neighbors:
				assert(checkInBounds(neighIndexes))
