extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hoovered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.material.set_shader_param("width", 0.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (self.hoovered):
		#$Sprite.material.set_shader_param("width", 4.0)
		$Sprite.material.set_shader_param("outline_color", Color(0.5, 0.6, 0.8, 1.0))
	#else:
		#self.get_child(0).material.set_shader_param("width", 0.0)
		#$Sprite.material.set_shader_param("width", 0.0)

func _on_Tile_mouse_entered():
	self.hoovered = true
	$Sprite.material.set_shader_param("width", 4.0)

func _on_Tile_mouse_exited():
	self.hoovered = false
	$Sprite.material.set_shader_param("width", 0.0)
