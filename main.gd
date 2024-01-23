extends Node

var score = 0
@onready var score_label = $ScoreLabel  # Assurez-vous que le chemin vers le Label est correct

func _ready():
	var enemy_spawner = $EnemySpawner
	enemy_spawner.connect("enemy_killed", Callable(self, "_on_enemy_killed"))
	

func _on_enemy_killed():
	print("on killed")
	score += 1
	score_label.text = "Score: " + str(score)
