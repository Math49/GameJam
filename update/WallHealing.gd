extends Button

var cost = 10  # Coût initial de l'amélioration
var monaie = Globals.monaie
signal wallHealing

func _ready():
	update_button_state()

func _process(delta):
	monaie = Globals.monaie
	update_button_state()

func _on_Button_pressed():
	if monaie >= cost:
		Globals.monaie -= cost
		cost *= 1.5
		var path_to_wall = "../../.."  # Remonte jusqu'à 'main'
		var wall_node = get_node(path_to_wall).get_node("wall")
		if wall_node:
			wall_node.set_health(Globals.Wall_health)
		else:
			print("Le noeud 'wall' n'a pas été trouvé.")
		update_button_state()
	else:
		print("Pas assez de monnaie")

func update_button_state():
	text = "Soigner (" + str(cost) + ")"
	disabled = monaie < cost
