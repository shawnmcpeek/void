extends Area2D

var move_speed: float = 100
var move_direction: Vector2 = Vector2.DOWN

# Metadata for each file: [texture, bar_height, bar_count]
var bar_files = [
	{
		"texture": preload("res://assets/images/obstacles/HealthBar_16x3.png"),
		"bar_height": 3,
		"bar_count": 6
	},
	{
		"texture": preload("res://assets/images/obstacles/HealthBar_32x9.png"),
		"bar_height": 9,
		"bar_count": 4
	},
	{
		"texture": preload("res://assets/images/obstacles/HealthBar_72x9.png"),
		"bar_height": 9,
		"bar_count": 4
	},
	{
		"texture": preload("res://assets/images/obstacles/HealthBar_72x16.png"),
		"bar_height": 16,
		"bar_count": 4
	},
	{
		"texture": preload("res://assets/images/obstacles/HealthBar_106x16.png"),
		"bar_height": 16,
		"bar_count": 4
	},
	{
		"texture": preload("res://assets/images/obstacles/HealthBar_108x12.png"),
		"bar_height": 12,
		"bar_count": 4
	}
]

func _ready():
	# Randomly select a file
	var file_data = bar_files[randi() % bar_files.size()]
	
	# Set texture and enable region
	$Sprite2D.texture = file_data["texture"]
	$Sprite2D.region_enabled = true
	
	# Randomly select a bar within the file
	var bar_index = randi() % file_data["bar_count"]
	$Sprite2D.region_rect = Rect2(
		0,  # X starts at 0
		bar_index * file_data["bar_height"],  # Y position
		file_data["texture"].get_width(),     # Full width
		file_data["bar_height"]               # Single bar height
	)
	
	# Resize collision to match the visible bar
	$CollisionShape2D.shape.size = Vector2(
		file_data["texture"].get_width(),
		file_data["bar_height"]
	)
	
	add_to_group("obstacle")
	area_entered.connect(_on_area_entered)

func _process(delta):
	position += move_speed * move_direction * delta
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player"):
		print("Player hit obstacle!")
		# Handle collision (game over, damage, etc.)
