extends Area2D

enum PlantType {NONE, CHAMPIGNON, LIERE, EUCALYPTUS, SECOIA, RONCE}
enum BuildingType {NONE, PARCKING, USINE, HOTEL, ROAD}

var PType = PlantType.NONE
var BType = BuildingType.NONE

export var startTile = false

onready var plant : Sprite = get_node("Plant")
onready var building : Sprite = get_node("Building")

#return True si il y a une plante
func hasPlant():
	return PType != PlantType.NONE
	
func getBulding():
	match BType:
		BuildingType.NONE:
			return "NONE"
		BuildingType.PARCKING:
			return "PARCKING"
		BuildingType.USINE:
			return "USINE"
		BuildingType.HOTEL:
			return "HOTEL"
		BuildingType.ROAD:
			return "ROAD"

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				print("c")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Tiles")
	$BackGround.material.set_shader_param("width", 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Tile_mouse_entered():
	$BackGround.material.set_shader_param("width", 4.0)
	self.z_index = 1

func _on_Tile_mouse_exited():
	$BackGround.material.set_shader_param("width", 0.0)
	self.z_index = 0
