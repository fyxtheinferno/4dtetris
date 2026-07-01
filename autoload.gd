extends Node

var pc_queue = []
var hold: Piece = null

class Piece:
	var blocks: Array[Vector4i]
	var pivot: Vector4
	var type: int
	var preview: Resource

	func _init(p_blocks: Array[Vector4i], p_pivot: Vector4, p_type: int, p_preview: Resource):
		blocks = p_blocks
		pivot = p_pivot
		type  = p_type
		preview = p_preview

var i_piece = Piece.new(
	[Vector4i(0,0,0,0), Vector4i(1,0,0,0), Vector4i(2,0,0,0), Vector4i(3,0,0,0)],
	Vector4(1.5,0.5,1.5,0),
	2,
	preload("res://textures/i_piece.png")
)

var l_piece = Piece.new(
	[Vector4i(0,0,0,0), Vector4i(1,0,0,0), Vector4i(2,0,0,0), Vector4i(0,0,1,0)],
	Vector4(1,0,0,0),
	3,
	preload("res://textures/l_piece.png")
)

var o_piece = Piece.new(
	[Vector4i(0,0,0,0), Vector4i(1,0,0,0), Vector4i(0,0,1,0), Vector4i(1,0,1,0)],
	Vector4(0.5,0.5,0.5,0),
	4,
	preload("res://textures/o_piece.png")
)

var s_piece = Piece.new(
	[Vector4i(0,0,0,0), Vector4i(1,0,0,0), Vector4i(1,0,1,0), Vector4i(2,0,1,0)],
	Vector4(1,0,0,0),
	5,
	preload("res://textures/s_piece.png")
)

var t_piece = Piece.new(
	[Vector4i(1,0,0,0), Vector4i(2,0,0,0), Vector4i(1,0,1,0), Vector4i(0,0,0,0)],
	Vector4(1,0,0,0),
	6,
	preload("res://textures/t_piece.png")
)

var tower = Piece.new(
	[Vector4i(0,0,0,0), Vector4i(1,0,0,0), Vector4i(1,0,1,0), Vector4i(0,1,0,0)],
	Vector4(0.5,0.5,0.5,0),
	7,
	preload("res://textures/tower.png")
)

var tripod = Piece.new(
	[Vector4i(0,0,0,0), Vector4i(1,0,0,0), Vector4i(0,0,1,0), Vector4i(0,1,0,0)],
	Vector4(0,0,0,0),
	8,
	preload("res://textures/tripod.png")
)
