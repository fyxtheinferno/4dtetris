extends Node3D

@onready var gridmap = $GridMap

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gridmap.set_cell_item(Vector3i(0, 0, 0), 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
