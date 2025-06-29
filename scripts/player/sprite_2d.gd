extends Area2D

var speed = 200
var target_position = position
var sprite_half_width = 16  # Set to half your sprite width
var sprite_half_height = 16 # Set to half your sprite height

func _ready():
	area_entered.connect(_on_area_entered)
	add_to_group("player")

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target_position = get_global_mouse_position()

func _process(delta):
	# Existing movement logic
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		target_position = position + (input_vector * speed * 10 * delta)
	
	position = position.move_toward(target_position, speed * delta)
	
	# Simple boundary check with sprite size
	if position.x < sprite_half_width:
		position.x = sprite_half_width
	elif position.x > get_window().size.x - sprite_half_width:
		position.x = get_window().size.x - sprite_half_width
	
	if position.y < sprite_half_height:
		position.y = sprite_half_height
	elif position.y > get_window().size.y - sprite_half_height:
		position.y = get_window().size.y - sprite_half_height

signal player_died

func _on_area_entered(area):
	if area.is_in_group("obstacle"):
		print("OBSTACLE HIT! Game over logic here")
		emit_signal("player_died")
	elif area.is_in_group("orb"):
		print("ORB COLLECTED! Add score here")
		area.queue_free()
