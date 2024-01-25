extends Area2D

var speed = 400
var direction = Vector2.ZERO
var color = Color(0.0, 0.0, 0.0, 0)
var attack_duration = 0.1

func _process(delta):
	position += direction * speed * delta

func _ready():
	$zone.monitoring = false

func set_direction(dir):
	direction = dir.normalized()

func _on_area_entered(area):
	if area.is_in_group("enemies") or area.is_in_group("Mini-Boss") or area.is_in_group("Boss"):
		area.take_damage(Globals.Tank_Damage)
		zone()
		await get_tree().create_timer(attack_duration).timeout
		queue_free()


func zone():
	if $zone != null:
		direction = Vector2.ZERO
		$Sprite2D.hide()
		$zone.monitoring = true
		color = Color(1.0, 0.0, 0.0, 1)
		queue_redraw()
		await get_tree().create_timer(attack_duration).timeout  # Attendre la durée de l'attaque
		$zone.monitoring = false
		color = Color(0.0, 0.0, 0.0, 0)
		queue_redraw()

func draw_circle_arc_poly(color):
	var radius = 200
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
	
func _draw():
	draw_circle_arc_poly(color)
	
func _on_Zone_area_entered(area):
	if area.is_in_group("enemies") or area.is_in_group("Mini-Boss") or area.is_in_group("Boss"):
		area.take_damage(Globals.Tank_Damage)
