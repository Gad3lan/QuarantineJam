extends MarginContainer

var attaqueShow = false
var auxiliaireShow = false
var biomasseShow = false
var soutiensShow = false

onready var menuContainer = get_node("VBoxContainer/MenuContainer")
onready var attaqueMenu = get_node("VBoxContainer/MenuContainer/Attaque")
onready var auxiliaireMenu = get_node("VBoxContainer/MenuContainer/Auxilliaire")
onready var biomasseMenu = get_node("VBoxContainer/MenuContainer/Biomasse")
onready var soutiensMenu = get_node("VBoxContainer/MenuContainer/Soutien")

# Called when the node enters the scene tree for the first time.
func _ready():
	attaqueMenu.hide()
	auxiliaireMenu.hide()
	biomasseMenu.hide()
	soutiensMenu.hide()
	
func _process(delta):
	if attaqueShow || auxiliaireShow || biomasseShow || soutiensShow:
		pass

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

func _on_Attaque_mouse_exited():
	attaqueMenu.hide()

func _on_Auxilliaire_mouse_exited():
	auxiliaireMenu.hide()

func _on_Biomasse_mouse_exited():
	biomasseMenu.hide()

func _on_Soutien_mouse_exited():
	soutiensMenu.hide()
