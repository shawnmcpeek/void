extends Area2D

enum EyeType { WHITE, RED, REFLECTIVE }

@export var eye_type: EyeType = EyeType.WHITE
@export var max_health: float = 100.0
@export var light_tolerance: float = 2.0  # Seconds before becoming aggressive
@export var move_speed: float = 80.0
@export var attack_speed: float = 150.0

var current_health: float
var light_exposure_time: float = 0.0
var is_aggressive: bool = false
var is_visible: bool = false
var target_position: Vector2
var spawn_position: Vector2

# Visual components
var body_sprite: Sprite2D
var eye_sprite: Sprite2D
var shadow_effect: Sprite2D

# States
enum State { HIDDEN, VISIBLE, AGGRESSIVE, ATTACKING, DEAD }
var current_state: State = State.HIDDEN

func _ready():
	add_to_group("enemy")
	area_entered.connect(_on_area_entered)
	
	current_health = max_health
	spawn_position = global_position
	
	# Create visual components
	_create_visual_components()
	_update_visibility()

func _create_visual_components():
	# Main body (shadow)
	body_sprite = Sprite2D.new()
	body_sprite.texture = preload("res://assets/images/shadow_creature.png")  # We'll create this
	body_sprite.modulate = Color(0.1, 0.1, 0.1, 0.8)
	add_child(body_sprite)
	
	# Eyes based on type
	eye_sprite = Sprite2D.new()
	match eye_type:
		EyeType.WHITE:
			eye_sprite.texture = preload("res://assets/images/white_eyes.png")
			eye_sprite.modulate = Color(1.0, 1.0, 1.0, 0.9)
		EyeType.RED:
			eye_sprite.texture = preload("res://assets/images/red_eyes.png")
			eye_sprite.modulate = Color(1.0, 0.2, 0.2, 0.9)
		EyeType.REFLECTIVE:
			eye_sprite.texture = preload("res://assets/images/reflective_eyes.png")
			eye_sprite.modulate = Color(0.8, 0.8, 1.0, 0.9)
	
	add_child(eye_sprite)
	
	# Shadow effect
	shadow_effect = Sprite2D.new()
	shadow_effect.texture = preload("res://assets/images/shadow_aura.png")
	shadow_effect.modulate = Color(0.0, 0.0, 0.0, 0.6)
	shadow_effect.z_index = -1
	add_child(shadow_effect)

func _process(delta):
	match current_state:
		State.HIDDEN:
			_process_hidden_state(delta)
		State.VISIBLE:
			_process_visible_state(delta)
		State.AGGRESSIVE:
			_process_aggressive_state(delta)
		State.ATTACKING:
			_process_attacking_state(delta)
		State.DEAD:
			_process_dead_state(delta)

func _process_hidden_state(delta):
	# Subtle movement in darkness
	var time = Time.get_time_dict_from_system()
	var offset = Vector2(
		sin(time.second * 0.5) * 2,
		cos(time.second * 0.3) * 1
	)
	global_position = spawn_position + offset
	
	# Eyes barely visible
	eye_sprite.modulate.a = 0.1

func _process_visible_state(delta):
	# Eyes become more visible
	eye_sprite.modulate.a = min(eye_sprite.modulate.a + delta * 2, 0.9)
	
	# Subtle movement
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * move_speed * 0.3 * delta

func _process_aggressive_state(delta):
	# Eyes glow intensely
	eye_sprite.modulate.a = 0.9 + sin(Time.get_time_dict_from_system().second * 8) * 0.1
	
	# Move towards player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * move_speed * delta
		
		# Check if close enough to attack
		if global_position.distance_to(player.global_position) < 50:
			current_state = State.ATTACKING

func _process_attacking_state(delta):
	# Rapid movement towards player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * attack_speed * delta
		
		# Eyes flash rapidly
		eye_sprite.modulate.a = 0.5 + sin(Time.get_time_dict_from_system().second * 20) * 0.5

func _process_dead_state(delta):
	# Fade out
	modulate.a = max(modulate.a - delta * 2, 0)
	if modulate.a <= 0:
		queue_free()

func expose_to_light(delta):
	if current_state == State.DEAD:
		return
	
	light_exposure_time += delta
	
	if current_state == State.HIDDEN:
		current_state = State.VISIBLE
		_update_visibility()
	
	if light_exposure_time >= light_tolerance and current_state != State.AGGRESSIVE:
		current_state = State.AGGRESSIVE
		_update_visibility()
		_play_aggressive_sound()

func hide_from_light():
	if current_state == State.DEAD:
		return
	
	light_exposure_time = max(light_exposure_time - 0.5, 0)
	
	if light_exposure_time <= 0 and current_state == State.VISIBLE:
		current_state = State.HIDDEN
		_update_visibility()

func _update_visibility():
	match current_state:
		State.HIDDEN:
			body_sprite.modulate.a = 0.3
			shadow_effect.modulate.a = 0.8
		State.VISIBLE:
			body_sprite.modulate.a = 0.6
			shadow_effect.modulate.a = 0.5
		State.AGGRESSIVE:
			body_sprite.modulate.a = 0.8
			shadow_effect.modulate.a = 0.3
		State.ATTACKING:
			body_sprite.modulate.a = 1.0
			shadow_effect.modulate.a = 0.1

func take_damage(amount: float):
	current_health -= amount
	if current_health <= 0:
		current_state = State.DEAD
		_update_visibility()

func _play_aggressive_sound():
	# Play sound when becoming aggressive
	var audio_player = AudioStreamPlayer.new()
	var sound = preload("res://assets/sounds/creature_roar.ogg")  # We'll create this
	if sound:
		audio_player.stream = sound
		audio_player.volume_db = -10
		add_child(audio_player)
		audio_player.play()
		audio_player.finished.connect(audio_player.queue_free)

func _on_area_entered(area):
	if area.is_in_group("player") and current_state == State.ATTACKING:
		area.emit_signal("player_died")

func get_eye_type():
	return eye_type

func is_aggressive():
	return current_state == State.AGGRESSIVE or current_state == State.ATTACKING
