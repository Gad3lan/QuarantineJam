extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var timer = get_node("Timer")
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.set_wait_time(2)
	timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	self.queue_free()
	pass # Replace with function body.
