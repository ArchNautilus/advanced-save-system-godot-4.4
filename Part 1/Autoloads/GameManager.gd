extends Node

var player: CharacterBody2D = null

var player_spawn_position = Vector2.ZERO

var target_scene: String = ""

func save_game(player_position: Vector2, slot: int):
	var save = ConfigFile.new()
	save.set_value("Player", "x_position", player_position.x)
	save.set_value("Player", "y_position", player_position.y)
	
	var save_path: String = "user://save%d.cfg" % slot
	
	save.save(save_path)

func load_game(slot: int):
	var save = ConfigFile.new()
	var load_path: String = "user://save%d.cfg" % slot
	var err = save.load(load_path)
	if err != OK:
		print("No save file available.")
		return
	
	var x_position = save.get_value("Player", "x_position", 0.0)
	var y_position = save.get_value("Player", "y_position", 0.0)
	GameManager.player_spawn_position = Vector2(x_position, y_position)
