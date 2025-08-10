extends Node2D

# Enemy types and spawning
var enemy_scene = preload("res://scenes/enemy/ShadowCreature.tscn")
var enemy_types = ["white_eyes", "red_eyes", "reflective_eyes"]
var spawn_positions = []

# Spawning properties
var spawn_rate = 0.3  # Enemies per second
var max_enemies = 8
var difficulty_curve = 1.0
var path_width = 300.0

# Enemy behavior variations
var eye_type_weights = {
	"white_eyes": 0.5,      # Common, moderate threat
	"red_eyes": 0.3,        # Uncommon, high threat
	"reflective_eyes": 0.2  # Rare, very high threat
}

var spawn_timer = 0.0
var last_spawn_y = 0.0
var min_spawn_distance = 200.0

func _ready():
	randomize()
	_setup_spawn_positions()

func _setup_spawn_positions():
	# Create spawn positions along the path
	var screen_height = get_window().size.y
	var spawn_count = 5
	
	for i in range(spawn_count):
		var x_offset = randf_range(-path_width / 2 + 50, path_width / 2 - 50)
		var y_pos = -screen_height + (i * screen_height / spawn_count)
		spawn_positions.append(Vector2(x_offset, y_pos))

func _process(delta):
	spawn_timer += delta
	
	# Check if we should spawn an enemy
	if spawn_timer >= 1.0 / spawn_rate and get_tree().get_nodes_in_group("enemy").size() < max_enemies:
		_spawn_enemy()
		spawn_timer = 0.0
	
	# Update difficulty over time
	difficulty_curve += delta * 0.1
	spawn_rate = 0.3 + (difficulty_curve * 0.2)

func _spawn_enemy():
	var enemy = enemy_scene.instantiate()
	
	# Choose spawn position
	var spawn_pos = _get_spawn_position()
	if spawn_pos == Vector2.ZERO:
		return
	
	# Set enemy properties based on type
	var enemy_type = _choose_enemy_type()
	_setup_enemy_properties(enemy, enemy_type)
	
	# Position enemy
	enemy.global_position = Vector2(
		get_window().size.x / 2 + spawn_pos.x,
		spawn_pos.y
	)
	
	# Add to scene
	get_tree().current_scene.add_child(enemy)
	
	# Update last spawn position
	last_spawn_y = spawn_pos.y

func _get_spawn_position():
	# Find a spawn position that's far enough from the last spawn
	var valid_positions = []
	
	for pos in spawn_positions:
		if abs(pos.y - last_spawn_y) >= min_spawn_distance:
			valid_positions.append(pos)
	
	if valid_positions.size() == 0:
		return Vector2.ZERO
	
	return valid_positions[randi() % valid_positions.size()]

func _choose_enemy_type():
	var rand_val = randf()
	var cumulative_weight = 0.0
	
	for type in eye_type_weights:
		cumulative_weight += eye_type_weights[type]
		if rand_val <= cumulative_weight:
			return type
	
	return "white_eyes"  # Fallback

func _setup_enemy_properties(enemy, enemy_type):
	match enemy_type:
		"white_eyes":
			enemy.eye_type = enemy.EyeType.WHITE
			enemy.light_tolerance = 2.5
			enemy.move_speed = 60.0
			enemy.attack_speed = 120.0
			enemy.max_health = 80.0
			
		"red_eyes":
			enemy.eye_type = enemy.EyeType.RED
			enemy.light_tolerance = 1.8
			enemy.move_speed = 90.0
			enemy.attack_speed = 160.0
			enemy.max_health = 120.0
			
		"reflective_eyes":
			enemy.eye_type = enemy.EyeType.REFLECTIVE
			enemy.light_tolerance = 1.2
			enemy.move_speed = 110.0
			enemy.attack_speed = 200.0
			enemy.max_health = 150.0
	
	# Apply difficulty scaling
	enemy.light_tolerance = max(enemy.light_tolerance - (difficulty_curve * 0.1), 0.5)
	enemy.move_speed += difficulty_curve * 5.0
	enemy.attack_speed += difficulty_curve * 8.0

func set_difficulty(difficulty: float):
	difficulty_curve = max(difficulty, 0.1)
	spawn_rate = 0.3 + (difficulty_curve * 0.2)
	max_enemies = 6 + int(difficulty_curve * 2)

func get_current_difficulty():
	return difficulty_curve

func get_enemy_count():
	return get_tree().get_nodes_in_group("enemy").size()

func clear_all_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		enemy.queue_free()
