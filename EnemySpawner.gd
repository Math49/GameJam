extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var wave_number = 0
var enemies_per_wave = 5
var enemies_spawned_this_wave = 0
var enemies_alive = 0
var wave_in_progress = false
var enemy_health_increase = 10
var enemy_damage_increase = 10
var screen_size # Size of the game window.

signal enemy_killed
signal last_enemy_killed
signal enemy_hit_player

@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveTimer
@onready var wave_label = $WaveLabel as Label
@onready var timer_label = $TimerLabel as Label

func _ready():
	
	wave_timer.stop()
	spawn_timer.timeout.connect(_on_SpawnTimer_timeout)
	wave_timer.timeout.connect(_on_WaveTimer_timeout)
	launch_wave()

func _process(delta):
	if not wave_timer.is_stopped():
		timer_label.text = "Prochaine Vague Dans: " + str(int(wave_timer.time_left)) + "s"
	else:
		timer_label.text = "Vague en cours..."

func _on_WaveTimer_timeout():
	if not wave_in_progress:
		launch_wave()

func launch_wave():
	wave_number += 1
	enemies_spawned_this_wave = 0
	enemies_per_wave += 1
	enemies_alive = enemies_per_wave
	wave_in_progress = true
	wave_label.text = "Vague: " + str(wave_number)
	spawn_timer.start()

func spawn_enemy_delayed():
	if enemies_spawned_this_wave < enemies_per_wave:
		var interval = randf_range(1.0, 3.0)
		spawn_timer.start(interval)

func _on_SpawnTimer_timeout():
	if enemies_spawned_this_wave < enemies_per_wave:
		var enemy = enemy_scene.instantiate()
		enemy.max_health += enemy_health_increase * wave_number
		enemy.current_health = enemy.max_health
		enemy.damage += enemy_damage_increase * wave_number
		enemies_spawned_this_wave += 1
		enemy.enemy_killed.connect(_on_EnemyKilled)
		
		add_child(enemy)
		spawn_enemy_delayed()

func _on_EnemyKilled():
	enemies_alive -= 1
	if enemies_alive <= 0 and wave_in_progress:
		wave_in_progress = false
		wave_timer.start()
