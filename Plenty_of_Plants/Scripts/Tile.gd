tool
extends Area2D

onready var map = self.get_parent()

var mouseIsIn:bool = false
var baseZIndex
onready var pollen = preload("res://Scenes/BioMasse.tscn")

enum PlantType {NONE, CHAMPIGNON, LIERE, EUCALYPTUS, SECOIA, RONCE, HERBE}
enum BuildingType {NONE, PARCKING, USINE, HOTEL, ROAD0, ROAD1, ROAD2, ROAD3, ROAD4, ROAD5, ROAD6, HLM, IMMEUBLE, IMMEUBLE2, BUILDING, CENTRALE, TERRAIN}

var plantGivingBiomasse ={
	PlantType.SECOIA : 60,
	PlantType.EUCALYPTUS : 30,
	PlantType.HERBE : 80
}

export var coordOnTexture = Vector2(0,0)
export var root = false

export (PlantType) var PType = PlantType.NONE
export (BuildingType) var BType setget selectBuilding
var BType2 = BuildingType.NONE
export (int) var texturePart = 0

onready var timer = get_node("Timer")

onready var placeHolderPath = preload("res://Scenes/Prefabs/PlaceHolder.tscn")

onready var buildPaths = {
	BuildingType.NONE : preload("res://Scenes/Prefabs/NoBuilding.tscn"),
	BuildingType.PARCKING : preload("res://Scenes/Prefabs/Parcking.tscn")
}


#NONE, CHAMPIGNON, LIERE, EUCALYPTUS, SECOIA, RONCE, HERBE
onready var plantBuildingPath = {
	PlantType.SECOIA : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Sequoia.tscn")}},
	PlantType.HERBE : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Herbe.tscn")}},
	PlantType.EUCALYPTUS : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Eucalyptus.tscn")}},
	PlantType.CHAMPIGNON : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Champignon.tscn")}},
	PlantType.LIERE : {BuildingType.USINE:{Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourUsineFront.tscn")}}
}


var ROADPLACEHOLDER = -1

var plantBuildingcompatibleDict = {
	PlantType.NONE:[BuildingType.NONE],
	PlantType.CHAMPIGNON:[BuildingType.NONE, BuildingType.PARCKING, ROADPLACEHOLDER],
	PlantType.SECOIA:[BuildingType.NONE, BuildingType.PARCKING, ROADPLACEHOLDER],
	PlantType.EUCALYPTUS:[BuildingType.NONE, BuildingType.PARCKING, ROADPLACEHOLDER],
		PlantType.HERBE:[BuildingType.NONE, BuildingType.PARCKING,ROADPLACEHOLDER],
	PlantType.CHAMPIGNON:[BuildingType.NONE, BuildingType.PARCKING, ROADPLACEHOLDER,BuildingType.HOTEL],
	PlantType.LIERE:[BuildingType.HOTEL, BuildingType.USINE],
	PlantType.RONCE:[BuildingType.HOTEL, BuildingType.USINE],
}

export var startTile = false

onready var plant : Sprite = get_node("Plant")
onready var building : Sprite = get_node("Building")



#Fonction de l'outil
func selectBuilding(buildingType):
	BType2 = buildingType
	BType = buildingType
	if coordOnTexture != Vector2(0,0) || not root:
		return
	#Necessaire pour le fonctionnementt
	match buildingType:
		BuildingType.HOTEL:
			#Chargement de la texture
			$Building.texture = preload("res://Sprites/TileSprite/Building/Hôtel.png")
			#offset = -[taille sprite y]/ 2 + 90
			$Building.offset.y = -284
		BuildingType.PARCKING:
			$Building.texture = preload("res://Sprites/TileSprite/Building/parcking.png")
			$Building.offset.y = -102
		BuildingType.USINE:
			$Building.texture = preload("res://Sprites/TileSprite/Building/usine.png")
			$Building.offset.y = -485
		BuildingType.BUILDING:
			$Building.texture = preload("res://Sprites/TileSprite/Building/building.png")
			$Building.offset.y = -832
		BuildingType.CENTRALE:
			$Building.texture = preload("res://Sprites/TileSprite/Building/centrale electric.png")
			$Building.offset.y = -532
		BuildingType.HLM:
			$Building.texture = preload("res://Sprites/TileSprite/Building/HLM.png")
			$Building.offset.y = -565
		BuildingType.IMMEUBLE:
			$Building.texture = preload("res://Sprites/TileSprite/Building/immeuble.png")
			$Building.offset.y = -332.5
		BuildingType.ROAD0:
			$Building.texture = preload("res://Sprites/TileSprite/Building/angle 1.png")
			$Building.offset.y = 0
		BuildingType.ROAD1:
			$Building.texture = preload("res://Sprites/TileSprite/Building/angle 2.png")
			$Building.offset.y = 0
		BuildingType.ROAD2:
			$Building.texture = preload("res://Sprites/TileSprite/Building/carrefour.png")
			$Building.offset.y = 0
		BuildingType.ROAD3:
			$Building.texture = preload("res://Sprites/TileSprite/Building/coin 2.png")
			$Building.offset.y = 0
		BuildingType.ROAD4:
			$Building.texture = preload("res://Sprites/TileSprite/Building/coin.png")
			$Building.offset.y = 0
		BuildingType.ROAD5:
			$Building.texture = preload("res://Sprites/TileSprite/Building/route 1.png")
			$Building.offset.y = 0
		BuildingType.ROAD6:
			$Building.texture = preload("res://Sprites/TileSprite/Building/route 2.png")
			$Building.offset.y = 0
		BuildingType.IMMEUBLE2:
			$Building.texture = preload("res://Sprites/TileSprite/Building/immeuble 2.png")
			$Building.offset.y = -332.5
		BuildingType.TERRAIN:
			$Building.texture = preload("res://Sprites/TileSprite/Building/terrain vague.png")
			$Building.offset.y = -307.5
		_:
			#Texture vide
			$Building.texture = null
			$Building.offset.y = 0


var roads = [BuildingType.ROAD0, BuildingType.ROAD1, BuildingType.ROAD2, BuildingType.ROAD3, BuildingType.ROAD4, BuildingType.ROAD5, BuildingType.ROAD6]
func replacePlaceHolderOnDict():
	for key in plantBuildingcompatibleDict.keys():
		if plantBuildingcompatibleDict[key].has(ROADPLACEHOLDER):
			plantBuildingcompatibleDict[key].pop_back()
			for road in roads:
				plantBuildingcompatibleDict[key].push_back(road)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Tiles")
	replacePlaceHolderOnDict()


#return True si il y a une plante
func hasPlant():
	print(PType)
	return PType != PlantType.NONE
	

func plantCanBePlaced(plant):
	return PType == PlantType.NONE and plantBuildingcompatibleDict[plant].has(BType2)

func findPrefab():
	if plantBuildingPath[PType].has(BType2):
		return plantBuildingPath[PType][BType2][coordOnTexture]
	else:
		return plantBuildingPath[PType][BuildingType.NONE][coordOnTexture]

func instancePlant(type):
	print("plant type : ",type)
	var plantInstance
	if plantBuildingPath.has(type):
		PType = type
		plantInstance = findPrefab().instance()
	else:
		plantInstance = placeHolderPath.instance()
	plantInstance.z_index = self.z_index + 1
	call_deferred("add_child",plantInstance)
	if plantGivingBiomasse.has(PType):
		timer.set_wait_time(plantGivingBiomasse[PType] *(1+ 0.33*(randf()-0.5)))
		timer.start()

func setPlant(type):
	if not plantCanBePlaced(type):
		return false
	instancePlant(type)
	return true

func getBuilding():
	return BType

func _input(event):
	if mouseIsIn and event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
				if map.can_place(PlantType.LIERE,self):
					print("can place")
					setPlant(PlantType.LIERE)

func _on_Tile_mouse_entered():
	mouseIsIn = true
	baseZIndex = self.z_index
	$BackGround.material.set_shader_param("width", 4.0)
	self.z_index = 1

func _on_Tile_mouse_exited():
	mouseIsIn = false
	$BackGround.material.set_shader_param("width", 0.0)
	self.z_index = baseZIndex


func spawnPollen():
	var pollenInstance = pollen.instance()
	call_deferred("add_child",pollenInstance)
	pollenInstance.z_index = 2


func _on_Timer_timeout():
	timer.set_wait_time(plantGivingBiomasse[PType] *(1+ 0.33*(randf()-0.5)))
	timer.start()
	spawnPollen()
	pass # Replace with function body.
