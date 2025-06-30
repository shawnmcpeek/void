extends Area2D

@export var move_speed: float = 100
@export var move_direction: Vector2 = Vector2.DOWN

func _ready():
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
