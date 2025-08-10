extends Area2D

@export var move_speed: float = 100
@export var move_direction: Vector2 = Vector2.DOWN
@export var shift_distance: float = 500.0  # Large enough for full coverage
@export var shift_speed: float = 1.32
@export var fade_duration: float = 2.0

var start_x: float
var screen_width: float
var time: float = 0.0
var fade_progress: float = 0.0
var fade_completed: bool = false
@onready var color_rect = $ColorRect
@onready var collision_shape = $CollisionShape2D

@export var fade_in: bool = true

func _ready():
	screen_width = get_viewport_rect().size.x
	# Spawn anywhere, including screen edges
	start_x = randf_range(0, screen_width)
	# Connect signal
	if !area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	# Initialize shifting barriers
	if is_in_group("shifting_barrier"):
		if fade_in:
			color_rect.modulate.a = 0.0
			collision_shape.disabled = true
		else:
			color_rect.modulate.a = 1.0
			collision_shape.disabled = false

func _process(delta):
	time += delta
	# Vertical movement (ALL obstacles)
	position.y += move_speed * move_direction.y * delta
	# Horizontal oscillation with full coverage
	var t = sin(time * shift_speed)
	position.x = start_x + shift_distance * t
	# ONLY apply to shifting barriers
	if is_in_group("shifting_barrier") && !fade_completed:
		fade_progress = min(fade_progress + delta, fade_duration)
		if fade_in:
			# Fade IN: 0.0 -> 1.0
			color_rect.modulate.a = fade_progress / fade_duration
			collision_shape.disabled = (fade_progress / fade_duration) < 0.05
		else:
			# Fade OUT: 1.0 -> 0.0
			color_rect.modulate.a = 1.0 - (fade_progress / fade_duration)
			collision_shape.disabled = (1.0 - fade_progress / fade_duration) < 0.05
		# Mark completion when fade duration reached
		if fade_progress >= fade_duration:
			fade_completed = true
			if fade_in:
				color_rect.modulate.a = 1.0
				collision_shape.disabled = false
			else:
				color_rect.modulate.a = 0.0
				collision_shape.disabled = true
	# Boundary check (ALL obstacles)
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Player hit obstacle!")
