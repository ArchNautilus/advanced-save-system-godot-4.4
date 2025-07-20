extends Control

@export var row_limit: int = 4
@export var column_limit: int = 5
@export var icon_size: Vector2i = Vector2i(32, 32)

@onready var inventory_backdrop: TextureRect = $TextureRect
@onready var item_name_label: RichTextLabel = $ItemName
@onready var item_desc_label: RichTextLabel = $ItemDesc
@onready var item_icon_display: TextureRect = $ItemIcon

@export var cursor_texture: Texture2D

var selection_cursor: TextureRect
var selected_index: int = 0


func _ready() -> void:
	create_cursor()
	update_inventory()
	set_process(true)

func create_cursor():
	selection_cursor = TextureRect.new()
	selection_cursor.texture = cursor_texture
	selection_cursor.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	selection_cursor.size = icon_size
	inventory_backdrop.add_child(selection_cursor)
	update_cursor_position()

func update_cursor_position():
	var x = (selected_index % column_limit) * icon_size.x
	var y = (selected_index / column_limit) * icon_size.y
	selection_cursor.position = Vector2(x, y)
	update_item_info()

func update_item_info():
	var inventory = GameManager.get_inventory()
	if selected_index >= 0 and selected_index < inventory.size():
		var item = inventory[selected_index]
		
		item_name_label.text = item.item_name
		item_desc_label.text = item.item_desc
		item_icon_display.texture = item.item_icon
	else:
		item_name_label.text = ""
		item_desc_label.text = ""
		item_icon_display.texture = null

func update_inventory():
	for child in inventory_backdrop.get_children():
		if child != selection_cursor:
			child.queue_free()
	
	var inventory = GameManager.get_inventory()
	for i in range(inventory.size()):
		var item = inventory[i]
		
		var icon = TextureRect.new()
		icon.texture = item.item_icon
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.size = icon_size
		icon.position = Vector2(
			(i% column_limit) * icon_size.x,
			(i/column_limit) * icon_size.y
		)
		inventory_backdrop.add_child(icon)
	
	update_cursor_position()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		var inventory_size = GameManager.get_inventory().size()
		match event.keycode:
			KEY_RIGHT:
				if (selected_index + 1) % column_limit != 0 and selected_index + 1 < inventory_size:
					selected_index += 1
			KEY_LEFT:
				if selected_index % column_limit != 0:
					selected_index -= 1
			KEY_DOWN:
				if selected_index + column_limit < inventory_size:
					selected_index += column_limit
			KEY_UP:
				if selected_index - column_limit >= 0:
					selected_index -= column_limit
		update_cursor_position()


func _on_use_button_pressed() -> void:
	var inventory = GameManager.get_inventory()
	if selected_index >= 0 and selected_index < inventory.size():
		inventory.remove_at(selected_index)
		selected_index = clamp(selected_index, 0, inventory.size() - 1)
		update_inventory()
