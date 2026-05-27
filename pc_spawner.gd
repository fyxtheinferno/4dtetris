extends Node3D

@export var l_piece: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_block()
	
func spawn_block():
	var piece = l_piece.instantiate()
	add_child(piece)
