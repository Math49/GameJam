extends Area2D  # ou KinematicBody2D selon vos besoins

var current_health = Globals.Wall_health
signal enemy_entered
var screen_size

@onready var health_bar = $HealthBar  # Assurez-vous que le chemin vers le TextureProgress/ProgressBar est correct

func _ready():
	screen_size = get_viewport_rect().size
	position.x = 800
	position.y = screen_size.y
	health_bar.max_value = Globals.Wall_health
	health_bar.value = current_health


func _on_Wall_area_entered(area):
	if area.is_in_group("enemies"):
		emit_signal("enemy_entered", area)

func take_damage(damage):
	current_health -= damage
	health_bar.value = current_health
	if current_health <= 0:
		die()
		
func set_health(health_value):
	print(current_health)
	current_health = health_value
	
func die():
	queue_free()
