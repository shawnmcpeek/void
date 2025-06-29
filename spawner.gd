extends Node2D

# Configuration
@export var min_spawn_time: float = 1.0
@export var max_spawn_time: float = 3.0
@export var difficulty_curve: Curve
var spawn_timer: float = 0.0
var game_time: float = 0.0

# Obstacle scenes (assign in Inspector)
@export var obstacle_scenes: Array[PackedScene]

func _ready():
	spawn_timer = randf_range(min_spawn_time, max_spawn_time)

func _process(delta):
	game_time += delta
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_obstacle()
		# Adjust spawn time based on difficulty curve
		var difficulty = difficulty_curve.sample(game_time / 60.0)  # Scale over 1 minute
		spawn_timer = lerp(min_spawn_time, max_spawn_time, 1.0 - difficulty) * randf_range(0.8, 1.2)

func spawn_obstacle():
	if obstacle_scenes.size() == 0:
		return
	
	var obstacle = obstacle_scenes.pick_random().instantiate()
	var spawn_pos = Vector2(
		randf_range(50, get_viewport_rect().size.x - 50),
		-50  # Spawn above screen
	)
	
	obstacle.position = spawn_pos
	add_child(obstacle)
