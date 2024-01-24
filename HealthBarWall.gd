extends TextureProgressBar

@onready var health_label = $Label  # Assurez-vous que le chemin vers le Label est correct

func _ready():
	# initialiser la barre de santé et le label
	max_value = get_parent().max_health
	value = max_value
	update_health_label()

func _process(delta):
	value = get_parent().current_health
	update_health_label()

func update_health_label():
	health_label.text = str(int(value)) + "/" + str(int(max_value))
