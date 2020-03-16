tool
extends Area2D

onready var map = self.get_parent()
onready var pollen = preload("res://Scenes/BioMasse.tscn")
onready var Ui = map.get_parent().get_node("CameraNode").get_node("CanvasLayer/Ui")
onready var timer = get_node("Timer")
onready var placeHolderPath = preload("res://Scenes/Prefabs/PlaceHolder.tscn")
onready var plant : Sprite = get_node("Plant")
onready var building : Sprite = get_node("Building")
onready var lifeTimer = get_node("Life")
onready var buildPaths = {
	BuildingType.NONE : preload("res://Scenes/Prefabs/NoBuilding.tscn"),
	#BuildingType.PARCKING : preload("res://Scenes/Prefabs/Parcking.tscn")
}

enum PlantType {NONE, CHAMPIGNON, LIERE, TOURNESSOL, EUCALYPTUS,HERBE, SECOIA, MYCELIUM, RONCE}
enum BuildingType {NONE, PARCKING, USINE, HOTEL, ROAD0, ROAD1, ROAD2, ROAD3, ROAD4, ROAD5, ROAD6, HLM, IMMEUBLE, IMMEUBLE2, BUILDING, CENTRALE, TERRAIN}

export var coordOnTexture = Vector2(0,0)
export var root = false
export (PlantType) var PType = PlantType.NONE
export (BuildingType) var BType setget selectBuilding
export (int) var texturePart = 0
export var startTile = false

var mouseIsIn:bool = false
var baseZIndex
var BType2 = BuildingType.NONE
var ROADPLACEHOLDER = -1
var FLATPLACEHOLDER = -2
var WALLPLACEHOLDER = -3
var parent : Area2D
var life
var nbPlantsInTile
var textureName
var roads = [BuildingType.ROAD0, BuildingType.ROAD1, BuildingType.ROAD2, BuildingType.ROAD3, BuildingType.ROAD4, BuildingType.ROAD5, BuildingType.ROAD6]
var flats = [BuildingType.TERRAIN,BuildingType.PARCKING,BuildingType.NONE]
var walls = [BuildingType.HOTEL, BuildingType.USINE,BuildingType.BUILDING,BuildingType.CENTRALE,BuildingType.HLM,BuildingType.IMMEUBLE,BuildingType.IMMEUBLE2]
var plantGivingBiomasse ={
	PlantType.SECOIA : 60,
	PlantType.EUCALYPTUS : 30,
	PlantType.HERBE : 80
}
var plantBuildingcompatibleDict = {
	PlantType.NONE:[BuildingType.NONE],
	PlantType.CHAMPIGNON:[FLATPLACEHOLDER, ROADPLACEHOLDER],
	PlantType.SECOIA:[FLATPLACEHOLDER, ROADPLACEHOLDER],
	PlantType.EUCALYPTUS:[FLATPLACEHOLDER, ROADPLACEHOLDER],
	PlantType.HERBE:[FLATPLACEHOLDER,ROADPLACEHOLDER],
	PlantType.CHAMPIGNON:[FLATPLACEHOLDER, ROADPLACEHOLDER,BuildingType.HOTEL],
	PlantType.LIERE:[WALLPLACEHOLDER],
	PlantType.RONCE:[WALLPLACEHOLDER],
}
var buildingLife = {
	BuildingType.NONE:0,
	BuildingType.PARCKING:30,
	BuildingType.USINE:120,
	BuildingType.HOTEL:60,
	BuildingType.ROAD0:10,
	BuildingType.ROAD1:10,
	BuildingType.ROAD2:10,
	BuildingType.ROAD3:10,
	BuildingType.ROAD4:10,
	BuildingType.ROAD5:10,
	BuildingType.ROAD6:10,
	BuildingType.HLM:90,
	BuildingType.IMMEUBLE:60,
	BuildingType.IMMEUBLE2:60,
	BuildingType.BUILDING:120,
	BuildingType.CENTRALE:150,
	BuildingType.TERRAIN:20
}


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
			textureName = "res://Sprites/TileSprite/Building/Hôtel"
			#offset = -[taille sprite y]/ 2 + 90
			$Building.offset.y = -284
		BuildingType.PARCKING:
			textureName = "res://Sprites/TileSprite/Building/parking"
			$Building.offset.y = -102
		BuildingType.USINE:
			textureName = "res://Sprites/TileSprite/Building/usine"
			$Building.offset.y = -485
		BuildingType.BUILDING:
			textureName = "res://Sprites/TileSprite/Building/building"
			$Building.offset.y = -832
		BuildingType.CENTRALE:
			textureName = "res://Sprites/TileSprite/Building/centrale electric"
			$Building.offset.y = -532
		BuildingType.HLM:
			textureName = "res://Sprites/TileSprite/Building/HLM"
			$Building.offset.y = -565
		BuildingType.IMMEUBLE:
			textureName = "res://Sprites/TileSprite/Building/immeuble"
			$Building.offset.y = -332.5
		BuildingType.ROAD0:
			textureName = "res://Sprites/TileSprite/Building/angle 1"
			$Building.offset.y = 0
		BuildingType.ROAD1:
			textureName = "res://Sprites/TileSprite/Building/angle 2"
			$Building.offset.y = 0
		BuildingType.ROAD2:
			textureName = "res://Sprites/TileSprite/Building/carrefour"
			$Building.offset.y = 0
		BuildingType.ROAD3:
			textureName = "res://Sprites/TileSprite/Building/coin 2"
			$Building.offset.y = 0
		BuildingType.ROAD4:
			textureName = "res://Sprites/TileSprite/Building/coin"
			$Building.offset.y = 0
		BuildingType.ROAD5:
			textureName = "res://Sprites/TileSprite/Building/route 1"
			$Building.offset.y = 0
		BuildingType.ROAD6:
			textureName = "res://Sprites/TileSprite/Building/route 2"
			$Building.offset.y = 0
		BuildingType.IMMEUBLE2:
			textureName = "res://Sprites/TileSprite/Building/immeuble 2"
			$Building.offset.y = -332.5
		BuildingType.TERRAIN:
			textureName = "res://Sprites/TileSprite/Building/terrain vague"
			$Building.offset.y = -307.5
		_:
			#Texture vide
			$Building.texture = null
			$Building.offset.y = 0
	var toLoad = textureName + ".png"
	$Building.texture = load(toLoad)

func replacePlaceHolderOnDict():
	for key in plantBuildingcompatibleDict.keys():
		if plantBuildingcompatibleDict[key].has(ROADPLACEHOLDER):
			plantBuildingcompatibleDict[key].erase(ROADPLACEHOLDER)
			for road in roads:
				plantBuildingcompatibleDict[key].push_back(road)
		if plantBuildingcompatibleDict[key].has(FLATPLACEHOLDER):
			plantBuildingcompatibleDict[key].erase(FLATPLACEHOLDER)
			for flat in flats:
				plantBuildingcompatibleDict[key].push_back(flat)
		if plantBuildingcompatibleDict[key].has(WALLPLACEHOLDER):
			plantBuildingcompatibleDict[key].erase(WALLPLACEHOLDER)
			for wall in walls:
				plantBuildingcompatibleDict[key].push_back(wall)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Tiles")
	replacePlaceHolderOnDict()
	baseZIndex = self.z_index
	life = buildingLife.get(BType)
	lifeTimer.set_wait_time(1)
	nbPlantsInTile = 0

#return True si il y a une plante
func hasPlant():
	return PType != PlantType.NONE

func plantCanBePlaced(plant):
	return PType == PlantType.NONE and plantBuildingcompatibleDict[plant].has(BType2)

#NONE, CHAMPIGNON, LIERE, EUCALYPTUS, SECOIA, RONCE, HERBE
onready var plantBuildingPath = {
	PlantType.SECOIA : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Sequoia.tscn")}},
	PlantType.HERBE : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Herbe.tscn")}},
	PlantType.EUCALYPTUS : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Eucalyptus.tscn")}},
	PlantType.CHAMPIGNON : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Champignon.tscn")}},
	PlantType.LIERE : {BuildingType.BUILDING:{
			Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(0,0).tscn"),
			Vector2(1,0):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(1,0).tscn"),
			Vector2(2,0):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(2,0).tscn"),
			Vector2(3,0):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(3,0).tscn"),
			Vector2(0,1):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(0,1).tscn"),
			Vector2(0,2):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(0,2).tscn"),
			Vector2(0,3):preload("res://Scenes/Prefabs/LierrePourBuilding/LierrePourBuilding(0,3).tscn")
		},BuildingType.IMMEUBLE2:{
			Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourImmeuble1/LierrePourImmeuble1(0,0).tscn"),
			Vector2(1,0):preload("res://Scenes/Prefabs/LierrePourImmeuble1/LierrePourImmeuble1(1,0).tscn"),
		},BuildingType.CENTRALE:{
			Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(0,0).tscn"),
			Vector2(1,0):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(1,0).tscn"),
			Vector2(2,0):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(2,0).tscn"),
			Vector2(3,0):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(3,0).tscn"),
			Vector2(0,1):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(0,1).tscn"),
			Vector2(0,2):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(0,2).tscn"),
			Vector2(0,3):preload("res://Scenes/Prefabs/LierrePourCentraleElectrique/LierrePourCentraleElectrique(0,3).tscn")
		},BuildingType.IMMEUBLE:{
			Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourImmeuble2/LierrePourImmeuble2(0,0).tscn"),
			Vector2(0,1):preload("res://Scenes/Prefabs/LierrePourImmeuble2/LierrePourImmeuble2(0,1).tscn")
		},BuildingType.USINE:{
			Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(0,0).tscn"),
			Vector2(1,0):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(1,0).tscn"),
			Vector2(2,0):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(2,0).tscn"),
			Vector2(3,0):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(3,0).tscn"),
			Vector2(0,1):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(0,1).tscn"),
			Vector2(0,2):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(0,2).tscn"),
			Vector2(0,3):preload("res://Scenes/Prefabs/LierrePourUsine/LierrePourUsine(0,3).tscn")
		},BuildingType.HLM:{
			Vector2(0,0):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(0,0).tscn"),
			Vector2(1,0):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(1,0).tscn"),
			Vector2(2,0):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(2,0).tscn"),
			Vector2(3,0):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(3,0).tscn"),
			Vector2(0,1):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(0,1).tscn"),
			Vector2(0,2):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(0,2).tscn"),
			Vector2(0,3):preload("res://Scenes/Prefabs/LierrePourHLM/LierrePourHLM(0,3).tscn")
		}
	},
	PlantType.HERBE : {BuildingType.NONE:{Vector2(0,0):preload("res://Scenes/Prefabs/Herbe.tscn")}}
	
}
"""
			Vector2(0,0):preload(),
			Vector2(1,0):preload(),
			Vector2(2,0):preload(),
			Vector2(3,0):preload(),
			Vector2(0,1):preload(),
			Vector2(0,2):preload(),
			Vector2(0,3):preload()

			Vector2(0,0):preload(),
			Vector2(1,0):preload(),
			Vector2(2,0):preload(),
			Vector2(0,1):preload(),
			Vector2(0,2):preload()

			Vector2(0,0):preload(),
			Vector2(1,0):preload(),
			Vector2(0,1):preload()



"""

func hasPrefab(type):
	if plantBuildingPath[type].has(BType2) &&plantBuildingPath[type][BType2].has(coordOnTexture) :
		return true
	else:
		return plantBuildingPath[type].has(BuildingType.NONE)

func findPrefab():
	print("PType :", PType, " , dict ",plantBuildingPath[PType],", BType2 : ",BType2)
	if plantBuildingPath[PType].has(BType2):
		print("has")
		return plantBuildingPath[PType][BType2][coordOnTexture]
	else:
		return plantBuildingPath[PType][BuildingType.NONE][Vector2(0,0)]

func instancePlant(type):
	print("plant type : ",type)
	var plantInstance
	if plantBuildingPath.has(type)&& hasPrefab(type):
		PType = type
		print("finding prefab")
		plantInstance = findPrefab().instance()
	else:
		plantInstance = placeHolderPath.instance()
	plantInstance.z_as_relative =true
	plantInstance.z_index = 3
	call_deferred("add_child",plantInstance)
	if plantGivingBiomasse.has(PType):
		timer.set_wait_time(plantGivingBiomasse[PType] *(1+ 0.33*(randf()-0.5)))
		timer.start()

func setPlant(type):
	if not plantCanBePlaced(type):
		return false
	if (root):
		lifeTimer.start()
	nbPlantsInTile += 1
	instancePlant(type)
	return true

func getBuilding():
	return BType

func _input(event):
	if mouseIsIn and event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
			var toPlant = Ui.selectedPlant
			if map.can_place(toPlant,self):
				print("can place")
				setPlant(toPlant)

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
	pollenInstance.z_index = 4

func _on_Timer_timeout():
	timer.set_wait_time(plantGivingBiomasse[PType] *(1+ 0.33*(randf()-0.5)))
	timer.start()
	spawnPollen()


func _on_Life_timeout():
	life -= nbPlantsInTile
	if life <= 0:
		lifeTimer.stop()
		$Building.texture = load(textureName + "Destroyed.png")
