extends Button

onready var map = get_parent().get_parent().get_parent()

var add_Value = 0
var timeToDelete = 10

func _ready():
	$Timer.set_one_shot(true)
	$Timer.set_wait_time(timeToDelete)
	$Timer.connect("timeout", self, "_timer_callback")
	$Timer.start()

func _process(delta):
	#print($Timer.time_left/timeToDelete)
	# juste un test en cartion pour rendre la piece transparente avant qu'elle disparaisse
	var ratio = 0.5+$Timer.time_left/timeToDelete
	$Sprite.modulate = Color(1,1,1,ratio)
	if $Timer.time_left == 0 :
		self.queue_free()

func _input(event):
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	#print($Timer.time_left)
	if event is InputEventMouseButton &&  event.button_index == BUTTON_LEFT and event.pressed :
		print("test")

func _on_Button_pressed():
	if map != null:
		print(map)
		map.pickUpPollen()
	print("c")
	self.queue_free()
