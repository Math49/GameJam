extends Area2D

@export var speed = 500
@onready var health_bar = $HealthBar
var current_health = Globals.Player_Health 
var invulnerable = false
var invulnerability_duration = 3.0
var screen_size
var can_attack = true
var color = Color(0.0, 0.0, 0.0, 0)
var attack_duration = 0.2
var regen_amount = 10
var time_since_last_hit = 0.0
var regen_interval = 1.0
var time_to_start_regen = 2.0
 
signal interaction

func _ready():
	screen_size = get_viewport_rect().size
	position.x = 500
	position.y = screen_size.y
	$AttackArea2D.monitoring = false
	current_health = Globals.Player_Health
	health_bar.max_value = Globals.Player_Health
	health_bar.value = current_health

func _process(delta):
	if invulnerable:
		return
	
	if current_health < Globals.Player_Health:
		time_since_last_hit += delta
		if time_since_last_hit >= time_to_start_regen:
			time_since_last_hit = 0.0
			current_health = min(current_health + regen_amount, Globals.Player_Health)
			health_bar.value = current_health
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()
	if is_in_base() and Input.is_action_just_pressed("interact"):
		emit_signal("interaction")
		
	if velocity.x != 0:
		$Sprite2D.flip_v = false
		# See the note below about boolean assignment.
		$Sprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$Sprite2D.flip_v = velocity.y > 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	var capsule_radius = $CollisionShape2D.shape.radius
	var left_limit = capsule_radius
	var right_limit = screen_size.x - capsule_radius
	position.x = clamp(position.x, left_limit, right_limit)

func take_damage(amount):
	if invulnerable:
		return
	current_health -= amount
	time_since_last_hit = 0.0
	health_bar.value = current_health
	if current_health <= 0:
		respawn()

func respawn():
	position.x = 500
	position.y = screen_size.y
	current_health = Globals.Player_Health
	health_bar.value = current_health
	invulnerable = true
	set_process_input(false)
	await get_tree().create_timer(invulnerability_duration).timeout
	invulnerable = false
	set_process_input(true)
	time_since_last_hit = 0.0

func attack():
	if $AttackArea2D != null:
		can_attack = false
		$AttackArea2D.monitoring = true
		color = Color(1.0, 0.0, 0.0, 1)
		queue_redraw()
		await get_tree().create_timer(attack_duration).timeout  # Attendre la durée de l'attaque
		$AttackArea2D.monitoring = false
		color = Color(0.0, 0.0, 0.0, 0)
		$AttackTimer.start()
		queue_redraw()  # Activez la zone d'attaque

func _draw():
	draw_circle_arc_poly(color)

func _on_AttackTimer_timeout():
	can_attack = true

func draw_circle_arc_poly(color):
	var radius = 120
	var angle_from = 0
	var angle_to = 360
	var nb_points = 360
	var points_arc = PackedVector2Array()
	points_arc.push_back(Vector2(0, -80))
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(Vector2(0, -80) + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func _on_AttackArea2D_area_entered(area):
	if area.is_in_group("enemies"):  # Assurez-vous que les ennemis sont dans ce groupe
		area.take_damage(Globals.Player_Damage)
	if area.is_in_group("Mini-Boss"):  # Assurez-vous que les ennemis sont dans ce groupe
		area.take_damage(Globals.Player_Damage)
	if area.is_in_group("Boss"):  # Assurez-vous que les ennemis sont dans ce groupe
		area.take_damage(Globals.Player_Damage)

func is_in_base():
	for area in get_overlapping_areas():
		if area.name == "Base":  # Assurez-vous que votre base est dans un groupe nommé "Base"
			return true
	return false
