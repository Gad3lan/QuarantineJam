extends Node2D

export (float) var  sensibility = 1.5
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lastPos

# Called when the node enters the scene tree for the first time.
func _ready():
	lastPos = position
	pass # Replace with function body.
func moveCamera(delta):
	position = sensibility*(get_global_mouse_position() - lastPos)

func _input(event):
	print(event.type)
	if event.type == InputEventMouseButton:
		print(event.get_button_index())


func _process(delta):
	moveCamera(delta)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
