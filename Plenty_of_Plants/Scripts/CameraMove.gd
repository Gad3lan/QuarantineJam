extends Node2D

export (float) var minSensibilityRadius = 30.0
export (float) var  sensibilityRadius = 300.0
export (float) var maxSpeed = 1000.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lastMousePos
var rightClicking = false
var sensibility
# Called when the node enters the scene tree for the first time.
func _ready():
	sensibility = 1.0/sensibilityRadius
	lastMousePos = Vector2(0.0,0.0)
	pass # Replace with function body.



func moveCamera(delta):
	var vectorToMove = get_local_mouse_position() - lastMousePos
	var length = vectorToMove.length()
	if length < minSensibilityRadius:
		return
	vectorToMove *= sensibility
	if vectorToMove.length() > 1.0:
		vectorToMove = vectorToMove/vectorToMove.length()
	position += maxSpeed * vectorToMove * delta


func _input(event):
	if event is InputEventMouse:
		if event.is_pressed() && event.button_index == 2:
			print("rightClick")
			rightClicking = !rightClicking
			lastMousePos = get_local_mouse_position()

func _process(delta):
	if (rightClicking):
		moveCamera(delta)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
