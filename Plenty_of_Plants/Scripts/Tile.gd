extends Area2D

enum PlantType {NONE, CHAMPIGNON, LIERE}

var PType = PlantType.CHAMPIGNON

export var startTile = false

var hasPlant = false
var hasBuilding : bool = false


onready var plant : Sprite = get_node("Plant")
onready var building : Sprite = get_node("Building")

var canPlacePlant = false

func toggle_plantability(toggle):
	canPlacePlant = toggle

#func plant(toPlant):
#	hasPlant = true
#	plant.texture = toPlant

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				print("c")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


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
