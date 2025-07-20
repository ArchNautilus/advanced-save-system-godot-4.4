extends CharacterBody2D

@export var move_speed := 150.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var inventory: Control = $UI/Inventory
@onready var savemenu: Control = $UI/SaveMenu

@onready var interact: Area2D = $InteractArea2D
@onready var ui_text: RichTextLabel = $UI/DialogBox/RichTextLabel
@onready var textreader: AnimationPlayer = $TextReader
@onready var dialogbox: Control = $UI/DialogBox
@onready var interacttimer: Timer = $InteractTimer
@onready var interact_collision: CollisionShape2D = $InteractArea2D/CollisionShape2D

var input_vector := Vector2.ZERO

var is_reading: bool = false
var finished_text: bool = false

func _ready():
	GameManager.player = self
	savemenu.visible = false
	interact_collision.disabled = true
	dialogbox.visible = false
	inventory.visible = false
	self.global_position = GameManager.player_spawn_position

func toggle_finished_text():
	finished_text = !finished_text

func toggle_reading():
	is_reading = !is_reading

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape") and !is_reading:
		inventory.visible = !inventory.visible
	if Input.is_action_just_pressed("Interact") and !is_reading:
		interact_collision.disabled = false
	if Input.is_action_just_released("Interact") and !is_reading:
		interact_collision.disabled = true
	
	if finished_text and is_reading and Input.get_action_strength("Interact"):
		dialogbox.visible = false
		is_reading = false
		finished_text = false
	if !is_reading and inventory.visible == false:
		update_input()
		update_movement(delta)
		update_animation()

func update_input() -> void:
	input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

func update_movement(delta: float) -> void:
	velocity = input_vector * move_speed
	move_and_slide()

func update_animation() -> void:
	if input_vector == Vector2.ZERO:
		return

	if abs(input_vector.x) > abs(input_vector.y):
		# Horizontal movement
		if input_vector.x > 0:
			sprite.frame = 4  # Right (frame 5, 0-based index)
			interact.rotation = deg_to_rad(180.0)
		else:
			sprite.frame = 2  # Left (frame 3, 0-based index)
			interact.rotation = deg_to_rad(0.0)
	else:
		# Vertical movement
		if input_vector.y > 0:
			sprite.frame = 0  # Down (frame 1)
			interact.rotation = deg_to_rad(-90.0)
		else:
			sprite.frame = 1  # Up (frame 2)
			interact.rotation = deg_to_rad(90.0)

func readout_text():
	textreader.play("Readout-Text")

func parse_ui_text(item_name: String, looted: bool):
	dialogbox.visible = true
	if !looted:
		ui_text.text = "You came across a: " + item_name
	else:
		ui_text.text = "There is nothing inside..."

func _on_menu_button_pressed() -> void:
	savemenu.visible = true


func _on_interact_area_2d_body_entered(body: Node2D) -> void:
	interact_collision.disabled = true
	parse_ui_text(body.rsc_file.item_name, body.looted)
	readout_text()
	
	if !body.looted:
		GameManager.append_item(body.rsc_file)
		inventory.update_inventory()
		body.looted = true
		if body.has_method("save_state"):
			body.save_state()
