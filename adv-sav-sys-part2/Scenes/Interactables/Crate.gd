extends StaticBody2D

@export var looted: bool = false
@export var crate_id: String = ""
@export var rsc_file: Resource = null

func _ready():
	if LootboxTracker.crate_states.has(crate_id):
		looted = LootboxTracker.crate_states[crate_id]

func save_state():
	LootboxTracker.crate_states[crate_id] = looted
