extends Area2D

signal enemy_killed
signal last_enemy_killed
@onready var health_bar = $HealthBar
var speed = -150
var screen_size
var moving = true
var max_health = 500
var current_health = max_health
var damage = 50
var attacking_wall = false
var target_wall = null
var can_attack = true

func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x
	position.y = screen_size.y - 100
	health_bar.max_value = max_health
	health_bar.value = current_health

func _process(delta):
	
	if moving:
		var motion = Vector2(speed, 0) * delta
		position += motion
	elif target_wall != null and can_attack:
		can_attack = false
		target_wall.take_damage(damage)
		$AttackTimer.start()

	var extents = get_collision_shape_extents()
	if position.x < -extents.x:
		position.x = screen_size.x + extents.x
	elif position.x > screen_size.x + extents.x:
		position.x = -extents.x

func _on_AttackTimer_timeout():
	can_attack = true

func _on_MiniBoss_area_entered(area):
	if area.name == "Wall" or area.name == "Base":
		moving = false
		attacking_wall = true
		target_wall = area
		set_process(true)
	elif area.name == "Players":
		area.take_damage(damage)

func _on_MiniBoss_area_exited(area):
	if area.name == "Wall" or area.name == "Base":
		attacking_wall = false
		target_wall = null
		set_process(false)


func get_collision_shape_extents():
	return $CollisionShape2D.shape.extents

func take_damage(damage_amount):
	current_health -= damage_amount
	health_bar.value = current_health
	if current_health <= 0:
		die()

func die():
	get_parent().emit_signal("enemy_killed")
	queue_free()
