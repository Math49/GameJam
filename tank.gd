extends Node2D

@export var projectile_scene = preload("res://obus.tscn")
var screen_size
@onready var fire_timer = $FireTimer
var target_enemy = null

func _ready():
	var range_area = $range/CollisionShape2D
	fire_timer.wait_time = Globals.Tank_Rate
	fire_timer.start()
	screen_size = get_viewport_rect().size
	range_area.shape.radius = Globals.Tank_Range
	position.x = 450
	position.y = screen_size.y - 50

func _on_FireTimer_timeout():
	if target_enemy != null:
		var projectile = projectile_scene.instantiate()
		projectile.position = position
		var direction = (target_enemy.position - position).normalized()
		projectile.set_direction(direction)
		add_sibling(projectile)

func _on_Range_area_entered(area):
	if area.is_in_group("enemies") and target_enemy == null:
		target_enemy = area
	if area.is_in_group("Mini-Boss") or area.is_in_group("Boss") and target_enemy == null:
		target_enemy = area

func _on_Range_area_exited(area):
	if area == target_enemy:
		target_enemy = null
