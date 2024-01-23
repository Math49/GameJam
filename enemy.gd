extends Area2D

signal enemy_killed
signal last_enemy_killed

var speed = -100
var screen_size
var moving = true
var max_health = 20
var current_health = max_health
var damage = 5
var attacking_wall = false
var target_wall = null
var enemy_spawner = self

func _ready():
	screen_size = get_viewport_rect().size
	position.x = 1800
	position.y = 500

func _process(delta):
	if moving:
		var motion = Vector2(speed, 0) * delta
		position += motion
	elif target_wall != null:
		target_wall.take_damage(damage * delta)

	if position.x < -get_collision_shape_radius():
		position.x = screen_size.x + get_collision_shape_radius()
	elif position.x > screen_size.x + get_collision_shape_radius():
		position.x = -get_collision_shape_radius()

func _on_Enemy_area_entered(area):
	if area.name == "Wall":
		moving = false
		attacking_wall = true
		target_wall = area
		set_process(true)

func _on_Enemy_area_exited(area):
	if area.name == "Wall":
		attacking_wall = false
		target_wall = null
		set_process(false)

func get_collision_shape_radius():
	return $CollisionShape2D.shape.radius

func take_damage(damage_amount):
	current_health -= damage_amount
	if current_health <= 0:
		die()

func die():
	emit_signal("enemy_killed")
	#emit_signal("enemy_killed")
	#if enemies_spawned_this_wave >= enemies_per_wave:
		#enemy_spawner.emit_signal("last_enemy_killed")
	queue_free()
