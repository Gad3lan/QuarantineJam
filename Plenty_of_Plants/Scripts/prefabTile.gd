extends Node2D

export (int) var texturePart = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$toDelete.queue_free()
