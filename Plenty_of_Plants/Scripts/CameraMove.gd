extends Node2D

export (float) var minSensibilityRadius = 30.0
export (float) var  sensibilityRadius = 300.0
export (float) var maxSpeed = 1000.0
export (int) var zoomPos = 0
export (float) var zoomStep = 0.05

export (int) var minx = -3000
export (int) var maxx = 3000
export (int) var miny = -3000
export (int) var maxy = 3000

onready var camera = get_node("Camera2D")

var lastMousePos
var rightClick = false
var sensibility
var zoomTarget = zoomPos

# Called when the node enters the scene tree for the first time.
func _ready():
	sensibility = 1.0/sensibilityRadius
	lastMousePos = Vector2(0.0,0.0)

func rightClicking():
	if Input.is_mouse_button_pressed(2):
		return true
	rightClick = false
	return false

func normalizePos():
	if position.x < minx:
		position.x = minx
	if position.x > maxx:
		position.x = maxx

	if position.y < miny:
		position.y = miny
	if position.y > maxy:
		position.y = maxy

# Move the camera
func moveCamera(delta):
	var vectorToMove = get_local_mouse_position() - lastMousePos
	lastMousePos = get_local_mouse_position()
	var length = vectorToMove.length()
	if length < minSensibilityRadius:
		return
	if vectorToMove.length() > 1.0:
		vectorToMove = vectorToMove/vectorToMove.length()
	self.translate(maxSpeed * -vectorToMove * delta * camera.zoom)
	normalizePos()
	
# Controle le zoom de camera
func zoom(direcrion):
	if direcrion > 0:
		camera.zoom *= (1.0 + zoomStep)
		zoomPos += 1
	else:
		camera.zoom *= (1.0 - zoomStep)
		zoomPos -= 1

func _input(event):
	if event is InputEventPanGesture:
		camera.zoom *= (1.0 + event.delta.y / 10)
	if event is InputEventMouse:
		if event.is_pressed():
			if event.button_index == 2:
				rightClick = true
				lastMousePos = get_local_mouse_position()
			if event.button_index == BUTTON_WHEEL_UP: # zoom in
				zoomTarget -= 10
			if event.button_index == BUTTON_WHEEL_DOWN: # zoom out
				zoomTarget += 10

func _process(delta):
	if (rightClick && rightClicking()):
		moveCamera(delta)
	if (zoomTarget != zoomPos):
		zoom(zoomTarget - zoomPos)
