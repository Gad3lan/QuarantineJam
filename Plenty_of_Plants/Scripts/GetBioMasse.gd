extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event is InputEventMouseButton:
		#var mousePos = get_viewport().get_mouse_position()
		get_rect().has_point(to_local(event.position))
		if get_rect().has_point(to_local(event.position)) == true:
			visible = false
		#print(get_rect().has_point(to_local(event.position)))
