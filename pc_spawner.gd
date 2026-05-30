extends Node3D

@export var l_piece: PackedScene
@export var gridmap: GridMap

class Piece:
	var blocks: Array[Vector3i]
	var color: Color

	func _init(p_blocks: Array[Vector3i], p_color: Color):
		blocks = p_blocks
		color  = p_color


var t_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(0,0,1), Vector3i(-1,0,0)],
	Color.MEDIUM_PURPLE
)

# Called when the node enters the scene tree for the first time.
func _ready():
	for index in t_piece.blocks:
		gridmap.set_cell_item((index - Vector3i(1,0,2)), 0)

	
#func spawn_block():
	#var piece = l_piece.instantiate()
	#piece.locked.connect(_on_piece_locked)
	#add_child(piece)
#func _on_piece_locked():
	#spawn_block()
