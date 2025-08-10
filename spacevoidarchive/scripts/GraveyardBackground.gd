extends Node2D

# Graveyard elements
var gravestone_scenes = []
var fog_layers = []
var tree_shadows = []
var atmospheric_particles = []

# Environment properties
var fog_density = 0.7
var fog_speed = 0.5
var gravestone_spawn_rate = 0.8
var tree_shadow_spawn_rate = 0.6

# Scrolling properties
var scroll_speed = 100.0
var path_width = 300.0
var max_gravestones = 15
var max_tree_shadows = 8

func _ready():
	randomize()
	_load_graveyard_assets()
	_create_initial_environment()

func _load_graveyard_assets():
	# Load gravestone variations
	gravestone_scenes = [
		preload("res://assets/images/gravestone1.png"),
		preload("res://assets/images/gravestone2.png"),
		preload("res://assets/images/gravestone3.png"),
		preload("res://assets/images/gravestone4.png")
	]
	
	# Create fog layers
	_create_fog_layers()
	
	# Create atmospheric particles
	_create_atmospheric_particles()

func _create_fog_layers():
	# Multiple fog layers for depth
	for i in range(3):
		var fog = Sprite2D.new()
		fog.texture = preload("res://assets/images/fog.png")  # We'll create this
		fog.modulate = Color(0.8, 0.8, 0.8, 0.3 - i * 0.1)
		fog.scale = Vector2(2.0 + i * 0.5, 1.0)
		fog.z_index = -10 + i
		fog.position = Vector2(get_window().size.x / 2, get_window().size.y / 2 + i * 100)
		add_child(fog)
		fog_layers.append(fog)

func _create_atmospheric_particles():
	# Create floating particles for atmosphere
	var particle_system = GPUParticles2D.new()
	particle_system.emitting = true
	particle_system.amount = 50
	particle_system.lifetime = 10.0
	particle_system.explosiveness = 0.0
	particle_system.direction = Vector2(0, -1)
	particle_system.spread = 180.0
	particle_system.initial_velocity_min = 10.0
	particle_system.initial_velocity_max = 30.0
	particle_system.gravity = Vector2(0, 5.0)
	
	# Particle appearance
	var particle_material = ParticleProcessMaterial.new()
	particle_material.gravity = Vector2(0, 5.0)
	particle_material.initial_velocity_min = 10.0
	particle_material.initial_velocity_max = 30.0
	particle_material.angular_velocity_min = -90.0
	particle_material.angular_velocity_max = 90.0
	particle_material.linear_accel_min = -5.0
	particle_material.linear_accel_max = 5.0
	
	particle_system.process_material = particle_material
	
	# Particle texture
	var particle_texture = preload("res://assets/images/particle.png")  # We'll create this
	if particle_texture:
		particle_system.texture = particle_texture
	
	particle_system.modulate = Color(0.6, 0.6, 0.7, 0.4)
	particle_system.z_index = -20
	add_child(particle_system)
	atmospheric_particles.append(particle_system)

func _create_initial_environment():
	# Create initial gravestones
	for i in range(max_gravestones):
		_spawn_gravestone()
	
	# Create initial tree shadows
	for i in range(max_tree_shadows):
		_spawn_tree_shadow()

func _spawn_gravestone():
	var gravestone = Sprite2D.new()
	
	# Random gravestone type
	var texture = gravestone_scenes[randi() % gravestone_scenes.size()]
	gravestone.texture = texture
	
	# Random position along the path
	var x_offset = randf_range(-path_width / 2, path_width / 2)
	var y_pos = randf_range(-get_window().size.y, get_window().size.y * 2)
	gravestone.position = Vector2(get_window().size.x / 2 + x_offset, y_pos)
	
	# Random rotation and scale
	gravestone.rotation = randf_range(-0.1, 0.1)
	gravestone.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
	
	# Dark appearance
	gravestone.modulate = Color(0.3, 0.3, 0.3, 0.9)
	gravestone.z_index = -5
	
	add_child(gravestone)

func _spawn_tree_shadow():
	var tree_shadow = Sprite2D.new()
	tree_shadow.texture = preload("res://assets/images/tree_shadow.png")  # We'll create this
	
	# Position on sides of path
	var side = 1 if randf() > 0.5 else -1
	var x_offset = (path_width / 2 + 50) * side
	var y_pos = randf_range(-get_window().size.y, get_window().size.y * 2)
	tree_shadow.position = Vector2(get_window().size.x / 2 + x_offset, y_pos)
	
	# Dark shadow appearance
	tree_shadow.modulate = Color(0.1, 0.1, 0.1, 0.7)
	tree_shadow.z_index = -15
	
	add_child(tree_shadow)
	tree_shadows.append(tree_shadow)

func _process(delta):
	# Scroll environment elements
	_scroll_environment(delta)
	
	# Update fog movement
	_update_fog(delta)
	
	# Spawn new elements as needed
	_manage_spawning(delta)

func _scroll_environment(delta):
	# Move all gravestones and tree shadows
	for child in get_children():
		if child is Sprite2D:
			child.position.y += scroll_speed * delta
			
			# Remove if off screen
			if child.position.y > get_window().size.y + 200:
				child.queue_free()

func _update_fog(delta):
	# Move fog layers at different speeds
	for i in range(fog_layers.size()):
		var fog = fog_layers[i]
		fog.position.y += (scroll_speed * 0.3 + i * 20) * delta
		
		# Wrap fog around
		if fog.position.y > get_window().size.y + 200:
			fog.position.y = -200

func _manage_spawning(delta):
	# Spawn new gravestones
	if get_tree().get_nodes_in_group("gravestone").size() < max_gravestones:
		if randf() < gravestone_spawn_rate * delta:
			_spawn_gravestone()
	
	# Spawn new tree shadows
	if tree_shadows.size() < max_tree_shadows:
		if randf() < tree_shadow_spawn_rate * delta:
			_spawn_tree_shadow()

func set_fog_density(density: float):
	fog_density = clamp(density, 0.0, 1.0)
	for i in range(fog_layers.size()):
		var fog = fog_layers[i]
		fog.modulate.a = (0.3 - i * 0.1) * fog_density

func get_path_width():
	return path_width

func get_scroll_speed():
	return scroll_speed
