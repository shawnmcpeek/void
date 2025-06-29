extends Node

var is_game_over = false
var game_over_scene = preload("res://ui/GameOver.tscn") # Change path if needed

func _ready():
	# Connect to player's signal
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.player_died.connect(game_over)
	else:
		push_error("Player node not found in group 'player'")

func game_over():
	if is_game_over:
		return
	is_game_over = true
	print("GAME OVER")
	get_tree().paused = true
	# Show game over screen
	var screen = game_over_scene.instantiate()
	get_tree().root.add_child(screen)

func reset_game():
	is_game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()
