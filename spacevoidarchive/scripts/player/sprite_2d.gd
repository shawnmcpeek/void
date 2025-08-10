extends Area2D

# Flashlight properties
var flashlight_angle = 0.0
var flashlight_range = 300.0
var flashlight_angle_speed = 3.0
var max_flashlight_angle = 45.0  # Degrees

# Movement properties
var path_position = 0.0  # Position along the infinite path
var path_speed = 100.0   # Forward movement speed
var lateral_speed = 80.0 # Left/right movement speed
var target_lateral = 0.0 # Target lateral position
var max_lateral_offset = 150.0

# Light exposure tracking
var light_exposure_timer = 0.0
var max_exposure_time = 2.0  # Seconds before enemies attack
var nearby_enemies = []

# Visual elements
var flashlight_beam: Polygon2D
var flashlight_light: Light2D

signal player_died

func _ready():
	area_entered.connect(_on_area_entered)
	add_to_group("player")
	
	# Create flashlight beam
	_create_flashlight_beam()
	_create_flashlight_light()

func _create_flashlight_beam():
	flashlight_beam = Polygon2D.new()
	flashlight_beam.color = Color(1.0, 0.95, 0.8, 0.3)  # Warm light color
	add_child(flashlight_beam)
	_update_flashlight_beam()

func _create_flashlight_light():
	flashlight_light = Light2D.new()
	
	# Create a simple light texture programmatically
	var light_texture = _create_light_texture()
	flashlight_light.texture = light_texture
	
	flashlight_light.energy = 1.0
	flashlight_light.color = Color(1.0, 0.95, 0.8)
	flashlight_light.range_item_cull_mask = 1  # Layer for enemies
	add_child(flashlight_light)

func _create_light_texture():
	# Create a simple circular light texture
	var image = Image.create(64, 64, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	
	var center = Vector2(32, 32)
	var radius = 30
	
	for x in range(64):
		for y in range(64):
			var distance = Vector2(x, y).distance_to(center)
			if distance <= radius:
				var alpha = 1.0 - (distance / radius)
				alpha = alpha * alpha  # Smooth falloff
				image.set_pixel(x, y, Color(1, 1, 1, alpha))
	
	var texture = ImageTexture.create_from_image(image)
	return texture

func _input(event):
	# Flashlight angle control
	if event is InputEventMouseMotion:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		flashlight_angle = atan2(direction.y, direction.x)
		flashlight_angle = clamp(flashlight_angle, -deg_to_rad(max_flashlight_angle), deg_to_rad(max_flashlight_angle))
	
	# Keyboard controls for flashlight
	if event.is_action_pressed("ui_left"):
		flashlight_angle -= deg_to_rad(flashlight_angle_speed)
	if event.is_action_pressed("ui_right"):
		flashlight_angle += deg_to_rad(flashlight_angle_speed)
	
	flashlight_angle = clamp(flashlight_angle, -deg_to_rad(max_flashlight_angle), deg_to_rad(max_flashlight_angle))
	
	# Lateral movement
	if event.is_action_pressed("ui_left"):
		target_lateral = max(target_lateral - 50, -max_lateral_offset)
	if event.is_action_pressed("ui_right"):
		target_lateral = min(target_lateral + 50, max_lateral_offset)

func _process(delta):
	# Forward movement along path
	path_position += path_speed * delta
	
	# Lateral movement
	var current_lateral = position.x - get_window().size.x / 2
	current_lateral = move_toward(current_lateral, target_lateral, lateral_speed * delta)
	position.x = get_window().size.x / 2 + current_lateral
	
	# Update flashlight
	_update_flashlight_beam()
	_update_flashlight_light()
	
	# Check for enemies in light
	_check_enemies_in_light(delta)
	
	# Update player position for infinite scrolling effect
	position.y = get_window().size.y - 100  # Keep player at bottom

func _update_flashlight_beam():
	# Create a cone-shaped beam
	var beam_points = []
	var beam_angle = deg_to_rad(30)  # Beam width
	var segments = 8
	
	# Beam origin
	beam_points.append(Vector2.ZERO)
	
	# Beam edges
	for i in range(segments + 1):
		var angle = flashlight_angle - beam_angle + (beam_angle * 2 * i / segments)
		var point = Vector2(cos(angle), sin(angle)) * flashlight_range
		beam_points.append(point)
	
	flashlight_beam.polygon = beam_points

func _update_flashlight_light():
	flashlight_light.rotation = flashlight_angle
	flashlight_light.position = Vector2.ZERO

func _check_enemies_in_light(delta):
	var light_area = get_tree().get_nodes_in_group("enemy")
	nearby_enemies.clear()
	
	for enemy in light_area:
		if _is_enemy_in_light(enemy):
			nearby_enemies.append(enemy)
			enemy.expose_to_light(delta)
		else:
			enemy.hide_from_light()

func _is_enemy_in_light(enemy):
	var enemy_pos = enemy.global_position
	var player_pos = global_position
	var direction_to_enemy = (enemy_pos - player_pos).normalized()
	var distance_to_enemy = player_pos.distance_to(enemy_pos)
	
	# Check if enemy is within flashlight range
	if distance_to_enemy > flashlight_range:
		return false
	
	# Check if enemy is within flashlight angle
	var angle_to_enemy = atan2(direction_to_enemy.y, direction_to_enemy.x)
	var angle_diff = abs(angle_to_enemy - flashlight_angle)
	
	# Normalize angle difference
	if angle_diff > PI:
		angle_diff = 2 * PI - angle_diff
	
	return angle_diff <= deg_to_rad(15)  # Half the beam width

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		print("ENEMY HIT! Game over logic here")
		emit_signal("player_died")
	elif area.is_in_group("orb"):
		print("ORB COLLECTED! Add score here")
		area.queue_free()

func get_flashlight_angle():
	return flashlight_angle

func get_flashlight_range():
	return flashlight_range
