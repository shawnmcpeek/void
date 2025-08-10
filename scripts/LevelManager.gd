extends Node2D

# Full-screen background system for infinite vertical scrolling
var background_images = []  # Will store your PNG textures
var active_backgrounds = []  # Currently visible backgrounds
var screen_height := 1280  # Vertical mobile game height
var background_height := 1280  # Height of each background image
var scroll_speed := 200  # Speed of background scrolling

func _ready():
	# Load your full-screen background images
	_load_background_images()
	
	# Create initial background
	_create_background(0)

func _process(delta):
	# Handle up/down input for background scrolling
	var scroll_direction = 0
	if Input.is_action_pressed("ui_up"):
		scroll_direction = 1  # Move backgrounds down (forward)
	elif Input.is_action_pressed("ui_down"):
		scroll_direction = -1  # Move backgrounds up (backward)
	
	# Move all active backgrounds
	for background in active_backgrounds:
		background.position.y += scroll_direction * scroll_speed * delta
	
	# Check if we need a new background above
	var top_background_y = active_backgrounds[0].position.y if active_backgrounds.size() > 0 else 0
	if scroll_direction > 0 and top_background_y > -background_height / 2:
		_create_background(top_background_y - background_height)
	
	# Remove backgrounds that are too far below
	var bottom_background_y = active_backgrounds[-1].position.y if active_backgrounds.size() > 0 else 0
	if scroll_direction < 0 and bottom_background_y < background_height * 1.5:
		_remove_bottom_background()

func _load_background_images():
	# Load your actual full-screen PNG backgrounds
	var background_paths = [
		"res://assets/backgrounds/001.png",
		"res://assets/backgrounds/002.png",
		"res://assets/backgrounds/003.png",
		"res://assets/backgrounds/004.png",
		"res://assets/backgrounds/005.png",
		"res://assets/backgrounds/006.png",
		"res://assets/backgrounds/007.png",
		"res://assets/backgrounds/008.png",
		"res://assets/backgrounds/009.png",
		"res://assets/backgrounds/010.png"
	]
	
	for path in background_paths:
		var texture = load(path)
		if texture:
			background_images.append(texture)
			print("Loaded background: ", path)
		else:
			print("Failed to load background: ", path)
	
	print("Loaded ", background_images.size(), " background images")

func _create_background(y_position):
	# Choose a random background image
	var random_texture = background_images[randi() % background_images.size()]
	
	# Create the background sprite
	var background = Sprite2D.new()
	background.texture = random_texture
	background.position = Vector2(0, y_position)
	background.z_index = -1  # Render behind everything else
	
	# Center the background
	background.centered = true
	
	add_child(background)
	active_backgrounds.insert(0, background)
	
	print("Created background at Y: ", y_position)

func _remove_bottom_background():
	if active_backgrounds.size() > 2:  # Keep at least 2 backgrounds
		var bottom_background = active_backgrounds.pop_back()
		bottom_background.queue_free()
		print("Removed bottom background")
