extends MarginContainer

var attaqueShow = false
var auxiliaireShow = false
var biomasseShow = false
var soutiensShow = false

onready var attaqueMenu = get_node("VBoxContainer/HBoxContainer/Attaque")
onready var auxiliaireMenu = get_node("VBoxContainer/HBoxContainer/Auxilliaire")
onready var biomasseMenu = get_node("VBoxContainer/HBoxContainer/Biomasse")
onready var soutiensMenu = get_node("VBoxContainer/HBoxContainer/Soutien")

# Called when the node enters the scene tree for the first time.
func _ready():
	attaqueMenu.hide()
	auxiliaireMenu.hide()
	biomasseMenu.hide()
	soutiensMenu.hide()
	
func _process(delta):
	match true:
		attaqueShow:
			attaqueMenu.show()
		auxiliaireShow:
			auxiliaireMenu.show()
		biomasseShow:
			biomasseMenu.show()
		soutiensShow:
			soutiensMenu.show()

func _on_Attaque_mouse_entered():
	attaqueShow = true
	attaqueMenu.show()

func _on_Auxiliaire_mouse_entered():
	auxiliaireShow = true
	auxiliaireMenu.show()

func _on_Biomasse_mouse_entered():
	biomasseShow = true
	biomasseMenu.show()

func _on_Soutien_mouse_entered():
	soutiensShow = true
	soutiensMenu.show()
