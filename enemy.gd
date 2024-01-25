extends Area2D

signal enemy_killed
signal last_enemy_killed

var speed = -100
var screen_size
var moving = true
var max_health = 20
var current_health = max_health
var damage = 10
var attacking_wall = false
var target_wall = null
var can_attack = true

func _ready():
	screen_size = get_viewport_rect().size
	position.x = screen_size.x
	position.y = screen_size.y - 50

func _process(delta):
	
	if moving:
		var motion = Vector2(speed, 0) * delta
		position += motion
	elif target_wall != null and can_attack:
		can_attack = false
		target_wall.take_damage(damage)
		$AttackTimer.start()

	if position.x < -get_collision_shape_radius():
		position.x = screen_size.x + get_collision_shape_radius()
	elif position.x > screen_size.x + get_collision_shape_radius():
		position.x = -get_collision_shape_radius()

func _on_AttackTimer_timeout():
	can_attack = true

func _on_Enemy_area_entered(area):
	if area.name == "Wall" or area.name == "Base":
		moving = false
		attacking_wall = true
		target_wall = area
		set_process(true)
	elif area.name == "Players":
		area.take_damage(damage)

func _on_Enemy_area_exited(area):
	if area.name == "Wall" or area.name == "Base":
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
	get_parent().emit_signal("enemy_killed")
	queue_free()
