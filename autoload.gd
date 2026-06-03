extends Node

var pc_queue = []
var hold: Piece

class Piece:
	var blocks: Array[Vector3i]
	var type: int
	var preview: Resource

	func _init(p_blocks: Array[Vector3i], p_type: int, p_preview: Resource):
		blocks = p_blocks
		type  = p_type
		preview = p_preview

var i_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(2,0,0), Vector3i(3,0,0)],
	2,
	preload("res://textures/i_piece.png")
)

var l_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(2,0,0), Vector3i(0,0,1)],
	3,
	preload("res://textures/l_piece.png")
)

var o_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(0,0,1), Vector3i(1,0,1)],
	4,
	preload("res://textures/o_piece.png")
)

var s_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(1,0,1), Vector3i(2,0,1)],
	5,
	preload("res://textures/s_piece.png")
)

var t_piece = Piece.new(
	[Vector3i(1,0,0), Vector3i(2,0,0), Vector3i(1,0,1), Vector3i(0,0,0)],
	6,
	preload("res://textures/t_piece.png")
)

var tower = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(1,0,1), Vector3i(0,1,0)],
	7,
	preload("res://textures/tower.png")
)

var tripod = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(0,0,1), Vector3i(0,1,0)],
	8,
	preload("res://textures/tripod.png")
)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
