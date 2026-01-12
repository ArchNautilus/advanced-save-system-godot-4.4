extends CharacterBody2D

@export var move_speed := 150.0
@onready var sprite: Sprite2D = $Sprite2D
@onready var inventory: Control = $UI/Inventory
@onready var savemenu: Control = $UI/SaveMenu

var input_vector := Vector2.ZERO

func _ready():
	GameManager.player = self
	savemenu.visible = false
	self.global_position = GameManager.player_spawn_position

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		inventory.visible = !inventory.visible
	
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

		if input_vector.x > 0:
			sprite.frame = 4
		else:
			sprite.frame = 2
	else:

		if input_vector.y > 0:
			sprite.frame = 0
		else:
			sprite.frame = 1


func _on_menu_button_pressed() -> void:
	savemenu.visible = true
