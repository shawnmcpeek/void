extends CharacterBody2D

var speed := 200
var flashlight_angle := 0.0  # Current flashlight angle in radians
var flashlight_rotation_speed := 2.0  # How fast the flashlight rotates

func _physics_process(delta):
	var move := Vector2.ZERO
	
	# Only allow left/right movement (lateral movement on the path)
	if Input.is_action_pressed("ui_left"):
		move.x -= 1
	if Input.is_action_pressed("ui_right"):
		move.x += 1
	
	if move.x != 0:
		move.x = move.x * speed
	
	velocity = move
	
	# Use built-in movement with collision support
	move_and_slide()
	
	# Update flashlight angle based on input
	_update_flashlight_angle(delta)
	
	# Add debug print for flashlight rotation
	var flashlight = get_node("PointLight2D")
	if flashlight:
		print("Flashlight rotation: ", rad_to_deg(flashlight.rotation))

func _update_flashlight_angle(delta):
	# Rotate flashlight left/right with A/D keys
	if Input.is_action_pressed("ui_left"):
		flashlight_angle -= flashlight_rotation_speed * delta
	if Input.is_action_pressed("ui_right"):
		flashlight_angle += flashlight_rotation_speed * delta
	
	# Keep angle within reasonable bounds (-45 to +45 degrees)
	flashlight_angle = clamp(flashlight_angle, -0.785, 0.785)  # -45° to +45°
	
	# Update the PointLight2D rotation
	var flashlight = get_node("PointLight2D")
	if flashlight:
		flashlight.rotation = flashlight_angle
	
	# Update the player sprite rotation to match flashlight direction
	var sprite = get_node("Sprite2D")
	if sprite:
		sprite.rotation = flashlight_angle

func _ready():
	var flashlight = get_node("PointLight2D")
	if flashlight:
		print("Flashlight (PointLight2D) found in _ready().")
		print("Flashlight energy: ", flashlight.energy)
		print("Flashlight texture: ", flashlight.texture)
		if flashlight.texture:
			print("Flashlight texture type: ", flashlight.texture.get_class())
	else:
		print("Flashlight (PointLight2D) NOT found in _ready().")
