extends Area2D

export var startTile = false

var hasPlant = false
var hasBuilding : bool = false


onready var plant : Sprite = get_node("Plant")
onready var building : Sprite = get_node("Building")

var canPlacePlant = false


func toggle_plantability(toggle):
	canPlacePlant = toggle

func plant(toPlant):
	hasPlant = true
	plant.texture = toPlant

func _on_Tile_input_event (viewport, event, shape_idx):
	
	pass
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Tiles")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
