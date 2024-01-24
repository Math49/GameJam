extends Node2D

@export var projectile_scene = preload("res://Projectile.tscn")
@export var fire_rate = 1.0
var screen_size
@onready var fire_timer = $FireTimer
var target_enemy = null
@onready var range_area = $range  # Assurez-vous que c'est le bon chemin vers votre Area2D "range"

func _ready():
	fire_timer.wait_time = fire_rate
	fire_timer.start()
	screen_size = get_viewport_rect().size
	position.x = 500
	position.y = screen_size.y - 200

func _on_FireTimer_timeout():
	if target_enemy != null:
		var projectile = projectile_scene.instantiate()
		projectile.position = position
		var direction = (target_enemy.position - position).normalized()
		projectile.set_direction(direction)
		print(projectile)
		add_child(projectile)

func _on_Range_area_entered(area):
	if area.is_in_group("enemies") and target_enemy == null:
		target_enemy = area

func _on_Range_area_exited(area):
	if area == target_enemy:
		target_enemy = null
