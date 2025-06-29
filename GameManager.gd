extends Node

var is_game_over = false

# Optional: Uncomment when you have a game over screen scene
# var game_over_screen = preload("res://GameOverScreen.tscn")

func game_over():
	if is_game_over:
		return
	is_game_over = true
	print("GAME OVER")
	get_tree().paused = true
	# Optional: Uncomment to show game over screen
	# var screen = game_over_screen.instantiate()
	# get_tree().root.add_child(screen)

func reset_game():
	is_game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()
