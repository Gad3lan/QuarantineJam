extends Area2D

onready var map = self.get_parent()

var mouseIsIn:bool = false

enum PlantType {NONE, CHAMPIGNON, LIERE, EUCALYPTUS, SECOIA, RONCE}
enum BuildingType {NONE, PARCKING, USINE, HOTEL, ROAD}

var plantBuildingcompatibleDict = {
	PlantType.NONE:[BuildingType.NONE],
	PlantType.CHAMPIGNON:[BuildingType.NONE, BuildingType.PARCKING, BuildingType.ROAD],
	PlantType.SECOIA:[BuildingType.NONE, BuildingType.PARCKING, BuildingType.ROAD],
	PlantType.EUCALYPTUS:[BuildingType.NONE, BuildingType.PARCKING, BuildingType.ROAD],
	PlantType.CHAMPIGNON:[BuildingType.NONE, BuildingType.PARCKING, BuildingType.ROAD,BuildingType.HOTEL],
	PlantType.LIERE:[BuildingType.HOTEL, BuildingType.USINE],
	PlantType.RONCE:[BuildingType.HOTEL, BuildingType.USINE]
}

var PType = PlantType.NONE
var BType = BuildingType.NONE

export var startTile = false

onready var plant : Sprite = get_node("Plant")
onready var building : Sprite = get_node("Building")

#return True si il y a une plante
func hasPlant():
	return PType != PlantType.NONE
	

func plantCanBePlaced(plant):
	return PType == PlantType.NONE and plantBuildingcompatibleDict[plant].has(BType)

func setPlant(type):
	if not plantCanBePlaced(type):
		return false
	match type:
		PlantType.SECOIA:
			plant.texture = load("res://Sprites/TileSprite/Plants/Séquoia.PNG")
			PType = type
		_:
			plant.texture = load("res://Sprites/vector-autumn-tree-12.png")
	return true


func getBuilding():
	return BType


func _input(event):
	if mouseIsIn and event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == BUTTON_LEFT:
				if map.can_place(PlantType.SECOIA,self):
					print("can place")
					setPlant(PlantType.SECOIA)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Tiles")
	$BackGround.material.set_shader_param("width", 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tile_mouse_entered():
	mouseIsIn = true
	$BackGround.material.set_shader_param("width", 4.0)
	self.z_index = 1

func _on_Tile_mouse_exited():
	mouseIsIn = false
	$BackGround.material.set_shader_param("width", 0.0)
	self.z_index = 0
