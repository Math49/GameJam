extends Area2D

var speed = 100
var direction = Vector2.ZERO

func _process(delta):
	position += direction * speed * delta
	print(position)

func set_direction(dir):
	direction = dir.normalized()
	print("dir")
