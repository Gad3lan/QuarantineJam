extends Area2D



# Declare member variables here. Examples:
var add_Value = 0
var timeToDelete = 6
# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.set_one_shot(true)
	$Timer.set_wait_time(timeToDelete)
	$Timer.connect("timeout", self, "_timer_callback")
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($Timer.time_left/timeToDelete)
	# juste un test en cartion pour rendre la piece transparente avant qu'elle disparaisse
	var ratio = 0.5+$Timer.time_left/timeToDelete
	$Sprite.modulate = Color(1,1,1,ratio)
	if $Timer.time_left == 0 :
		self.queue_free()

func _input(event):

	pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	print($Timer.time_left)
	if event is InputEventMouseButton &&  event.button_index == BUTTON_LEFT and event.pressed :
		self.queue_free()
		 # Je supprime l'objet directement au lieu de juste le cacher comme en bas
		#$Sprite.visible=false
