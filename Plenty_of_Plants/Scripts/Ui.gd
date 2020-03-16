extends MarginContainer

onready var menuContainer = get_node("VBoxContainer/MenuContainer")
onready var attaqueMenu = get_node("VBoxContainer/MenuContainer/Attaque")
onready var auxiliaireMenu = get_node("VBoxContainer/MenuContainer/Auxilliaire")
onready var biomasseMenu = get_node("VBoxContainer/MenuContainer/Biomasse")
onready var soutiensMenu = get_node("VBoxContainer/MenuContainer/Soutien")
onready var numNode = get_node("VBoxContainer/MenuPrincipale/Money/Label")

enum PlantType {NONE, CHAMPIGNON, LIERE, TOURNESSOL, EUCALYPTUS,HERBE, SECOIA, MYCELIUM, RONCE, BAMBOU, MOUSSE, ORTIE, HERBE, CONSOUD}

export (PlantType) var selectedPlant = PlantType.NONE;
export (int) var pollenNum = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	attaqueMenu.hide()
	auxiliaireMenu.hide()
	biomasseMenu.hide()
	soutiensMenu.hide()
	numNode.text = str(pollenNum)

func addPollen(n):
	pollenNum += n
	numNode.text = str(pollenNum)
	
func setPollen(n):
	pollenNum = n
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
	pass

func _on_Auxilliaire_mouse_exited():
	pass

func close_all():
	biomasseMenu.hide()
	soutiensMenu.hide()
	attaqueMenu.hide()
	auxiliaireMenu.hide()

func _on_Biomasse_mouse_exited():
	pass


func _on_Soutien_mouse_exited():
	pass

func _on_Champignon_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.CHAMPIGNON
		print("champignon")
		close_all()

func _on_Liere_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.LIERE
		print("LIERE : ",PlantType.LIERE)
		close_all()

func _on_Tournessole_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.TOURNESSOL
		print("TOURNESSOL")
		close_all()

func _on_Eucalyptus_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.EUCALYPTUS
		print("EUCALYPTUS")
		close_all()

func _on_Sequoia_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.SECOIA
		print("SECOIA")
		close_all()

func _on_Mycellium_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.MYCELIUM
		print("MYCELIUM")
		close_all()

func _on_Ronces_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.RONCE
		print("RONCE")
		close_all()

func _on_Bambou_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.BAMBOU
		print("BAMBOU")
		close_all()

func _on_Mousse_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.MOUSSE
		print("MOUSSE")
		close_all()

func _on_Ortie_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.ORTIE
		print("ORTIE")
		close_all()

func _on_Consoude_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.CONSOUD
		print("CONSOUD")
		close_all()

func _on_Herbe_gui_input(event):
	if event.is_pressed():
		selectedPlant = PlantType.HERBE
		print("HERBE")
		close_all()
