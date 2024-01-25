extends Area2D  # ou KinematicBody2D selon vos besoins

var max_health = 100
var current_health = max_health
signal enemy_entered
signal game_over
var screen_size

@onready var health_bar = $HealthBar  # Assurez-vous que le chemin vers le TextureProgress/ProgressBar est correct

func _ready():
	screen_size = get_viewport_rect().size
	position.x = 55
	position.y = 1000
	health_bar.max_value = max_health
	health_bar.value = current_health

func _on_Base_area_entered(area):
	if area.is_in_group("enemies") or area.is_in_group("Boss") or area.is_in_group("Mini-Boss"):
		emit_signal("enemy_entered", area)

func take_damage(damage):
	current_health -= damage
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die():
	queue_free()
	emit_signal("game_over")

