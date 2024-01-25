extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var mini_boss_scene = preload("res://mini_boss.tscn")
var boss_scene = preload("res://boss.tscn")
var wave_number = 0
var max_wave = 20
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
	wave_label.position.y = 100
	timer_label.position.y = 200
	wave_timer.stop()
	spawn_timer.timeout.connect(_on_SpawnTimer_timeout)
	wave_timer.timeout.connect(_on_WaveTimer_timeout)
	launch_wave()

func _process(delta):
	if not wave_timer.is_stopped():
		timer_label.text = "Prochaine Vague Dans: " + str(int(wave_timer.time_left)) + "s"
	else:
		if wave_number > max_wave:
			timer_label.text = "Fin de partie !"
		else:
			timer_label.text = "Vague en cours..."

func _on_WaveTimer_timeout():
	if not wave_in_progress:
		launch_wave()

func launch_wave():
	wave_number += 1
	if wave_number > max_wave:
		return
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
		var enemy_instance
		if wave_number == 10 and enemies_spawned_this_wave == enemies_per_wave - 1:
			enemy_instance = mini_boss_scene.instantiate()
		elif wave_number == 20 and enemies_spawned_this_wave == enemies_per_wave - 1:
			enemy_instance = boss_scene.instantiate()
		else:
			enemy_instance = enemy_scene.instantiate()
			enemy_instance.max_health += enemy_health_increase * wave_number
			enemy_instance.current_health = enemy_instance.max_health
			enemy_instance.damage += enemy_damage_increase * wave_number
			
		enemies_spawned_this_wave += 1
		enemy_instance.enemy_killed.connect(_on_EnemyKilled)
		add_child(enemy_instance)
		
		if not (wave_number == 10 or wave_number == 20 and enemies_spawned_this_wave == enemies_per_wave):
			spawn_enemy_delayed()

func _on_EnemyKilled():
	enemies_alive -= 1
	if enemies_alive <= 0 and wave_in_progress:
		wave_in_progress = false
		wave_timer.start()
