extends Area2D

# Movement variables
var speed = 200
var target_position = position

func _ready():
	# Connect collision signal
	area_entered.connect(_on_area_entered)
	add_to_group("player")

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target_position = get_global_mouse_position()

func _process(delta):
	# Keyboard movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		target_position = position + (input_vector * speed * 10 * delta)
	
	# Move toward target
	position = position.move_toward(target_position, speed * delta)

# Collision handling
func _on_area_entered(area):
	if area.is_in_group("obstacle"):
		print("OBSTACLE HIT! Game over logic here")
		# Add game over logic here
	elif area.is_in_group("orb"):
		print("ORB COLLECTED! Add score here")
		area.queue_free()
