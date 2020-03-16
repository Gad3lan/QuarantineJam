extends MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_Button_pressed():
	print("Jouer")
	get_tree().change_scene("res://Scenes/General.tscn")

func _on_Button2_pressed():
	get_tree().quit()
