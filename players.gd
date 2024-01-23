extends Area2D
signal hit

@export var speed = 500 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var attack_duration = 0.5
var color = Color(0.0, 0.0, 0.0, 0)
var can_attack = true

func _ready():
	screen_size = get_viewport_rect().size
	position.x = 500
	position.y = 500

func _process(delta):
	
	
	
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

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
	var radius = 100
	var angle_from = 0
	var angle_to = 360
	var nb_points = 360
	var points_arc = PackedVector2Array()
	points_arc.push_back(Vector2(0, 0))
	var colors = PackedColorArray([color])

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(Vector2(0, 0) + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)

func _on_AttackArea2D_area_entered(area):
	if area.is_in_group("enemies"):  # Assurez-vous que les ennemis sont dans ce groupe
		area.take_damage(10)

func _on_body_entered(_body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
