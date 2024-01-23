extends Node

var enemy_scene = preload("res://Enemy.tscn")
var wave_number = 0
@export var enemies_per_wave = 5
@export var enemies_spawned_this_wave = 0
var enemy_health_increase = 10
var enemy_damage_increase = 10

signal enemy_killed
signal last_enemy_killed

@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveTimer
@onready var wave_label = get_node("WaveLabel") as Label
@onready var timer_label = get_node("TimerLabel") as Label

func _ready():
	#if not spawn_timer.is_connected("timeout", Callable(self, "_on_SpawnTimer_timeout")):
		#spawn_timer.connect("timeout", Callable(self, "_on_SpawnTimer_timeout"))
	launch_wave()

func _process(delta):
	if not wave_timer.is_stopped():
		timer_label.text = "Prochaine Vague Dans: " + str(int(wave_timer.time_left)) + "s"

func _on_LastEnemyKilled():
	wave_timer.start()

func _on_WaveTimer_timeout():
	launch_wave()

func launch_wave():
	wave_number += 1
	enemies_spawned_this_wave = 0
	enemies_per_wave += 1
	wave_label.text = "Vague: " + str(wave_number)
	for i in range(enemies_per_wave):
		var interval = randf_range(0.2, 1.0)
		spawn_timer.start(interval)

func _on_SpawnTimer_timeout():
	if enemies_spawned_this_wave <= enemies_per_wave:
		var enemy = enemy_scene.instantiate()
		enemy.max_health += enemy_health_increase * wave_number
		enemy.current_health = enemy.max_health
		enemy.damage += + enemy_damage_increase * wave_number
		#enemy.enemyProps = self
		add_child(enemy)
		enemies_spawned_this_wave += 1
