extends Node2D

var score = 0
var screen_size
@onready var score_label = $ScoreLabel  # Assurez-vous que le chemin vers le Label est correct


func _on_enemy_killed():
	score += 1
	score_label.text = "Score: " + str(score)
