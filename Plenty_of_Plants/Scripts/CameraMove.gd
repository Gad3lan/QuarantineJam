extends Node2D

export (float) var minSensibilityRadius = 30.0
export (float) var  sensibilityRadius = 300.0
export (float) var maxSpeed = 1000.0
export (int) var zoomPos = 0
export (float) var zoomStep = 0.05

onready var camera = get_node("Camera2D")
onready var ui = get_node("Ui")

var lastMousePos
var rightClick = false
var sensibility
var zoomTarget = zoomPos

# Called when the node enters the scene tree for the first time.
func _ready():
	sensibility = 1.0/sensibilityRadius
	lastMousePos = Vector2(0.0,0.0)
	pass # Replace with function body.

func rightClicking():
	if Input.is_mouse_button_pressed(2):
		return true
	rightClick = false
	return false

# Move the camera
func moveCamera(delta):
	var vectorToMove = get_local_mouse_position() - lastMousePos
	var length = vectorToMove.length()
	if length < minSensibilityRadius:
		return
	vectorToMove *= sensibility
	if vectorToMove.length() > 1.0:
		vectorToMove = vectorToMove/vectorToMove.length()
	position += maxSpeed * -vectorToMove * delta
	
# Controle le zoom de camera
func zoom(direcrion):
	if direcrion > 0:
		camera.zoom *= (1.0 + zoomStep)
		ui.scale *= (1.0 + zoomStep)
		zoomPos += 1
	else:
		camera.zoom *= (1.0 - zoomStep)
		ui.scale *= (1.0 - zoomStep)
		zoomPos -= 1

func _input(event):
	if event is InputEventPanGesture:
		camera.zoom *= (1.0 + event.delta.y / 10)
		ui.scale *= (1.0 + event.delta.y / 10)
	if event is InputEventMouse:
		if event.is_pressed():
			if event.button_index == 2:
				rightClick = true
				lastMousePos = get_local_mouse_position()
			if event.button_index == BUTTON_WHEEL_UP: # zoom in
				zoomTarget += 10
			if event.button_index == BUTTON_WHEEL_DOWN: # zoom out
				zoomTarget -= 10

func _process(delta):
	if (rightClick && rightClicking()):
		moveCamera(delta)
	if (zoomTarget != zoomPos):
		zoom(zoomTarget - zoomPos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
