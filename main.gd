extends Node2D

var screen_size
@onready var score_label = $ScoreLabel  # Assurez-vous que le chemin vers le Label est correct
@onready var GameOver_label = $GameOver
@onready var amelioration = $Amelioration
var amelioration_show = true


func _ready():
	amelioration.hide()
	amelioration_show = true
	
func _process(delta):
	if Input.is_action_just_pressed("echap"):
		if amelioration.is_inside_tree():
			amelioration.hide()
			
	score_label.text = "Monaie: " + str(Globals.monaie)

func _on_enemy_killed():
	Globals.monaie += 5

func _on_game_over():
	screen_size = get_viewport_rect().size
	get_tree().paused = true
	GameOver_label.text = "Game Over !"
	GameOver_label.position = Vector2(screen_size.x/2, screen_size.y/2)
	
	$EnemySpawner.visible = false
	$Tourelle.visible = false
	$tank.visible = false
	$Players.visible = false

func _on_players_interaction():
	amelioration.show()
	amelioration_show = true
