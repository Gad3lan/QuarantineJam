extends MarginContainer

enum PlantType {NONE, CHAMPIGNON, LIERE, TOURNESSOL,HERBE, EUCALYPTUS, SECOIA, MYCELIUM, RONCE}

export (PlantType) var selectedPlant = PlantType.NONE;
export (int) var pollenNum = 0

onready var menuContainer = get_node("VBoxContainer/MenuContainer")
onready var attaqueMenu = get_node("VBoxContainer/MenuContainer/Attaque")
onready var auxiliaireMenu = get_node("VBoxContainer/MenuContainer/Auxilliaire")
onready var biomasseMenu = get_node("VBoxContainer/MenuContainer/Biomasse")
onready var soutiensMenu = get_node("VBoxContainer/MenuContainer/Soutien")
onready var numNode = get_node("VBoxContainer/MenuPrincipale/Money/Label")

# Called when the node enters the scene tree for the first time.
func _ready():
	attaqueMenu.hide()
	auxiliaireMenu.hide()
	biomasseMenu.hide()
	soutiensMenu.hide()
	showPollen()

func showPollen():
	numNode.text = str(pollenNum)
	

func _process(delta):
	pass

func _on_Attaque_mouse_entered():
	attaqueMenu.show()

func _on_Auxiliaire_mouse_entered():
	auxiliaireMenu.show()

func _on_Biomasse_mouse_entered():
	biomasseMenu.show()

func _on_Soutien_mouse_entered():
	soutiensMenu.show()

func _on_Attaque_mouse_exited():
	attaqueMenu.hide()

func _on_Auxilliaire_mouse_exited():
	auxiliaireMenu.hide()

func _on_Biomasse_mouse_exited():
	biomasseMenu.hide()

func _on_Soutien_mouse_exited():
	soutiensMenu.hide()

func _on_Champignon_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.CHAMPIGNON

func _on_Liere_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.LIERE

func _on_Tournessole_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.TOURNESSOL

func _on_Eucalyptus_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.EUCALYPTUS

func _on_Sequoia_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.SECOIA


func _on_Mycellium_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.MYCELIUM

func _on_Ronces_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.RONCE
