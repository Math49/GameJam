extends Label

func _ready():
	update_label_position()

func update_label_position():
	var screen_size = get_viewport_rect().size
	var label_rect = get_rect()
	var new_position = Vector2(
		(screen_size.x - label_rect.size.x) / 2,
		150
	)
	position = new_position
