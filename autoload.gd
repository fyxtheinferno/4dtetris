extends Node

var pc_queue = []
var hold: Piece = null

class Piece:
	var blocks: Array[Vector3i]
	var pivot: Vector3
	var type: int
	var preview: Resource

	func _init(p_blocks: Array[Vector3i], p_pivot: Vector3, p_type: int, p_preview: Resource):
		blocks = p_blocks
		pivot = p_pivot
		type  = p_type
		preview = p_preview

var i_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(2,0,0), Vector3i(3,0,0)],
	Vector3(1.5,0.5,1.5),
	2,
	preload("res://textures/i_piece.png")
)

var l_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(2,0,0), Vector3i(0,0,1)],
	Vector3(1,0,0),
	3,
	preload("res://textures/l_piece.png")
)

var o_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(0,0,1), Vector3i(1,0,1)],
	Vector3(0.5,0.5,0.5),
	4,
	preload("res://textures/o_piece.png")
)

var s_piece = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(1,0,1), Vector3i(2,0,1)],
	Vector3(1,0,0),
	5,
	preload("res://textures/s_piece.png")
)

var t_piece = Piece.new(
	[Vector3i(1,0,0), Vector3i(2,0,0), Vector3i(1,0,1), Vector3i(0,0,0)],
	Vector3(1,0,0),
	6,
	preload("res://textures/t_piece.png")
)

var tower = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(1,0,1), Vector3i(0,1,0)],
	Vector3(0.5,0.5,0.5),
	7,
	preload("res://textures/tower.png")
)

var tripod = Piece.new(
	[Vector3i(0,0,0), Vector3i(1,0,0), Vector3i(0,0,1), Vector3i(0,1,0)],
	Vector3(0,0,0),
	8,
	preload("res://textures/tripod.png")
)
