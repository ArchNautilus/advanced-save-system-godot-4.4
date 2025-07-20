extends Control

func _on_save_button_1_pressed() -> void:
	GameManager.save_game(GameManager.player.global_position, 1)


func _on_load_button_1_pressed() -> void:
	load_game(1)


func _on_save_button_2_pressed() -> void:
	GameManager.save_game(GameManager.player.global_position, 2)


func _on_load_button_2_pressed() -> void:
	load_game(2)


func _on_save_button_3_pressed() -> void:
	GameManager.save_game(GameManager.player.global_position, 2)


func _on_load_button_3_pressed() -> void:
	load_game(3)


func load_game(slot: int):
	GameManager.load_game(slot)
	
	var worldscene = "res://Scenes/World.tscn"
	var loadingScreen = load("res://Scenes/Menus/LoadingScreen.tscn")
	GameManager.target_scene = worldscene
	get_tree().change_scene_to_packed(loadingScreen)


func _on_return_button_pressed() -> void:
	visible = false
