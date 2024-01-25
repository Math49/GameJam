extends Area2D

var speed = 400
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta

func set_direction(dir):
	direction = dir.normalized()

func _on_area_entered(area):
	if area.is_in_group("enemies") or area.is_in_group("Mini-Boss") or area.is_in_group("Boss"):
		area.take_damage(Globals.Tourelle_Damage)
		queue_free()
