extends Node

var player: CharacterBody2D = null

var player_spawn_position = Vector2.ZERO

var target_scene: String = ""

var inventory: Array = []

func append_item(item: Resource) -> void:
	inventory.append(item)

func get_inventory() -> Array:
	return inventory

func save_game(player_position: Vector2, slot: int):
	var save = ConfigFile.new()
	save.set_value("Player", "x_position", player_position.x)
	save.set_value("Player", "y_position", player_position.y)
	
	var inv_paths: Array[String] = []
	for item in inventory:
		if item.resource_path != "":
			inv_paths.append(item.resource_path)
	save.set_value("Inventory", "items", inv_paths)
	
	for crate_id in LootboxTracker.crate_states.keys():
		save.set_value("Crates", crate_id, LootboxTracker.crate_states[crate_id])
	
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

	inventory.clear()
	var inv_paths = save.get_value("Inventory", "items", [])
	for path in inv_paths:
		var item = load(path)
		if item:
			inventory.append(item)
	
	LootboxTracker.crate_states.clear()
	for crate_id in save.get_section_keys("Crates"):
		var looted = save.get_value("Crates", crate_id, false)
		LootboxTracker.crate_states[crate_id] = looted
