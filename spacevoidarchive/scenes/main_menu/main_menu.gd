extends Control

# If using Maaack's Scene Loader:
# const SceneLoader = preload("res://addons/maaacks_scene_loader/SceneLoader.gd")

func _ready():
	# Connect buttons in code if not done in the editor
	pass

func _on_play_pressed():
	# Load the game scene
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
	# If using SceneLoader:
	# SceneLoader.load_scene("res://scenes/game/game.tscn")

func _on_options_pressed():
	# Open options menu (if you have one)
	pass

func _on_credits_pressed():
	# Open credits scene (if you have one)
	pass

func _on_quit_pressed():
	get_tree().quit()


func _on_new_game_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn")
