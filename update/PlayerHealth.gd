extends Button

var cost = 10  # Coût initial de l'amélioration
var improvement_amount = 10  # Quantité d'amélioration
var monaie = Globals.monaie


func _ready():
	update_button_state()

func _process(delta):
	monaie = Globals.monaie
	update_button_state()

func _on_Button_pressed():
	if monaie >= cost:
		Globals.monaie -= cost
		cost *= 1.5
		Globals.Player_Health += improvement_amount
		update_button_state()
		print("press")
	else:
		print("Pas assez de monnaie")

func update_button_state():
	text = "Améliorer (" + str(cost) + ")"
	disabled = monaie < cost
