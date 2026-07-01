extends Node3D

@export var grids: Array[GridMap]
@export var preview: PackedScene
class Grids:
	var grids: Array[GridMap]
	func _init(p_grids: Array[GridMap]):
		grids = p_grids
	
	func set_cell_item(pos: Vector4i, type: int):
		grids[pos.w].set_cell_item(Vector3i(pos.x, pos.y, pos.z), type)
	func get_cell_item(pos: Vector4i):
		return grids[pos.w].get_cell_item(Vector3i(pos.x, pos.y, pos.z))
	func get_used_cells() -> Array[Vector4i]:
		var cells: Array[Vector4i] = []
		for w in grids.size():
			for cell in grids[w].get_used_cells():
				cells.append(Vector4i(cell.x, cell.y, cell.z, w))
		return cells

var gridmap: Grids
signal held
signal spawned
signal cleared
signal game_over
var waxis_spawn: int = -1
var holdable: bool = true

var pc_list = [
	Autoload.i_piece,
	Autoload.l_piece,
	Autoload.o_piece,
	Autoload.s_piece,
	Autoload.t_piece,
	Autoload.tower,
	Autoload.tripod
]

var moving: Array[Vector4i]
var lowest: Array[Node] = []

var pc_instance: Autoload.Piece
var pivot: Vector4

var min_pos_xz = -4
var max_pos_xz = 0
var min_pos_y = -10
var drop_timer: float = 1.0
var lines_cleared = 0

const KICKS = [Vector4i(0,0,0,0),
			Vector4i(1,0,0,0),
			Vector4i(-1,0,0,0),
			Vector4i(0,1,0,0),
			Vector4i(0,-1,0,0),
			Vector4i(0,0,1,0),
			Vector4i(0,0,-1,0),
			Vector4i(0,0,0,1),
			Vector4i(0,0,0,-1),]
const START_OFFSET = Vector4i(-4,8,-4,0)
const GRIDMAP_SPACE_OFFSET = Vector3(-1,0,-1)
const W_OFFSET = Vector3(0,0,-30)
func spawn_block(custom: Autoload.Piece = null, from_hold: bool = false):
	if !from_hold: waxis_spawn += 1
	moving = []
	#if pc_queue.size < 7: generate 7-bag; add to queue
	if Autoload.pc_queue.size() < 7:
		pc_list.shuffle()
		Autoload.pc_queue.append_array(pc_list)
	
	var piece
	if custom:
		piece = custom
	else:
		piece = Autoload.pc_queue[0]

	pivot = piece.pivot + Vector4(START_OFFSET) + Vector4(0,0,0,waxis_spawn % 3)
	
	var tmp: Array[Vector4i] = []
	for block in piece.blocks:
		tmp.append(block + START_OFFSET + Vector4i(0,0,0,waxis_spawn % 3))
		
	if !is_valid_position(tmp):
		for i in tmp.size():
			tmp[i] = tmp[i] + Vector4i(0,1,0,0)
		if !is_valid_position(tmp): #still not valid? 
			set_process(false)
			game_over.emit()
			return false     
	
	moving = tmp
	for block in moving:
		gridmap.set_cell_item(block, piece.type)

	pc_instance = piece
	if !custom:
		Autoload.pc_queue.pop_front()
	if !from_hold:
		holdable = true
	pc_scan_lowest()
	
	spawned.emit()

func pc_move(mvmt: Vector4i, test: bool = false) -> bool:
	var end: Array[Vector4i] = []
	for i in moving.size():
		end.append(moving[i] + mvmt)
	var can_move = is_valid_position(end)
	
	if can_move && !test:
		pivot += Vector4(mvmt)
		for i in moving.size():
			gridmap.set_cell_item(moving[i], -1)
			moving[i] = end[i]
		for i in moving.size():
			gridmap.set_cell_item(moving[i], pc_instance.type)
	
	if mvmt.x != 0 || mvmt.z != 0 || mvmt.w != 0: pc_scan_lowest()
	
	return can_move

func pc_kick_rotate(axes) -> bool:
	for i in KICKS.size():
		pc_move(KICKS[i])
		if pc_rotate(axes):
			return true
		pc_move(Vector4i.ZERO - KICKS[i])
	return false
func pc_rotate(axes, test: bool = false) -> bool:
	var can_move = true
	var end: Array[Vector4] = []
	for i in moving.size():
		var plane: Array[int]
		for j in 4:
			if axes[j]: 
				plane.append(j)
		var origin = Vector2(pivot[plane[0]], pivot[plane[1]])
		var rotated = Transform2D(Vector2(0,-1), Vector2(1,0), origin) * Vector2(moving[i][plane[0]] - origin.x, moving[i][plane[1]] - origin.y)
		end.append(moving[i])
		end[i][plane[0]] = rotated[0]
		end[i][plane[1]] = rotated[1]
	can_move = is_valid_position(end)
	
	if can_move && !test:
		for i in moving.size():
			gridmap.set_cell_item(moving[i], -1)
			moving[i] = end[i]
		for i in moving.size():
			gridmap.set_cell_item(moving[i], pc_instance.type)
		pc_scan_lowest()

	return can_move
	
	
func is_valid_position(poses) -> bool:
	for pos in poses:
		if pos.x < min_pos_xz || pos.x > max_pos_xz:
			return false
		elif pos.z < min_pos_xz || pos.z > max_pos_xz:
			return false
		elif pos.y < min_pos_y:
			return false
		elif pos.w < 0 || pos.w >= gridmap.grids.size():
			return false

		elif pos not in moving && gridmap.get_cell_item(pos) != -1:
			return false
	
	return true

func pc_hold():
	if !holdable: return false
	var retrieved
	if Autoload.hold:
		var tmp = Autoload.hold
		Autoload.hold = pc_instance
		retrieved = tmp
	else:
		Autoload.hold = pc_instance

	for i in moving.size():
			gridmap.set_cell_item(moving[i], -1)
	
	holdable = false
	held.emit()
	spawn_block(retrieved, true)

func clear_line(y) -> bool:
	var clearable = true
	for w in gridmap.grids.size():
		for x in range(min_pos_xz, max_pos_xz+1):
			for z in range(min_pos_xz, max_pos_xz+1):
				if gridmap.get_cell_item(Vector4i(x,y,z,w)) == -1:
					clearable = false
	
	if clearable:
		for w in gridmap.grids.size():
			for x in range(min_pos_xz, max_pos_xz+1):
				for z in range(min_pos_xz, max_pos_xz+1):
					gridmap.set_cell_item(Vector4i(x,y,z,w), -1)
		
		var falling = []
		for block in gridmap.get_used_cells():
			if block.y > y:
				falling.append(block)
		
		if falling.size() > 0:
			falling.sort_custom(func(a,b): return a.y < b.y)
			for block in falling:
				gridmap.set_cell_item(block - Vector4i(0,1,0,0), gridmap.get_cell_item(block))
				gridmap.set_cell_item(block, -1)
	return clearable
				
func pc_lock():
	#use properties of dictionary to find all unique y coords block is positioned on; clear lines at coords
	var unique_y = {}
	for block in moving:
		unique_y[block.y] = true
		
	var mult = 0
	for y in unique_y.keys():
		if clear_line(y): mult += 1
	if mult > 0:
		cleared.emit(mult)
		if lines_cleared > 9:
			drop_timer *= 2
			$MoveTimer.wait_time = drop_timer
			$MoveTimer.start()
			lines_cleared = 0

	spawn_block()

func pc_scan_lowest(redraw: bool = true):
	var drop_dist = 0
	while pc_move(Vector4i(0,drop_dist - 1,0,0), true):
		drop_dist -= 1
	
	for i in moving.size():
		lowest[i].global_position = Vector3(moving[i].x, moving[i].y, moving[i].z) + Vector3(0,drop_dist,0) - GRIDMAP_SPACE_OFFSET + moving[i].w * W_OFFSET
	
func pc_hard_drop():
	pc_move(Vector4i(0,lowest[0].global_position.y-moving[0].y,0,0))
	pc_lock()

func _ready():
	gridmap = Grids.new(grids)
	for i in 4:
		var preview_inst = preview.instantiate()
		add_child(preview_inst)
		lowest.append(preview_inst)
	
	spawn_block()

func _process(_delta):
	if Input.is_action_just_pressed("move_x-"):
		pc_move(Vector4i(-1,0,0,0))
	if Input.is_action_just_pressed("move_x+"):
		pc_move(Vector4i(1,0,0,0))
	if Input.is_action_just_pressed("move_z-"):
		pc_move(Vector4i(0,0,-1,0))
	if Input.is_action_just_pressed("move_z+"):
		pc_move(Vector4i(0,0,1,0))
	if Input.is_action_just_pressed("move_w+"):
		pc_move(Vector4i(0,0,0,1))
	if Input.is_action_just_pressed("move_w-"):
		pc_move(Vector4i(0,0,0,-1))
	
	if Input.is_action_just_pressed("rotate_wx+"):
		pc_kick_rotate(Vector4(false, true, true, false))
	if Input.is_action_just_pressed("rotate_wy+"):
		pc_kick_rotate(Vector4(true, false, true, false))
	if Input.is_action_just_pressed("rotate_wz+"):
		pc_kick_rotate(Vector4(true, true, false, false))
	if Input.is_action_just_pressed("rotate_xy+"):
		pc_kick_rotate(Vector4(false, false, true, true))
	if Input.is_action_just_pressed("rotate_xz+"):
		pc_kick_rotate(Vector4(false, true, false, true))
	if Input.is_action_just_pressed("rotate_yz+"):
		pc_kick_rotate(Vector4(false, false, true, true))
	
	if Input.is_action_just_pressed("hold"):
		pc_hold()
	if Input.is_action_just_pressed("soft_drop"):
		if !pc_move(Vector4i(0,-1,0,0)):
			pc_lock()
		$MoveTimer.wait_time /= 20
		$MoveTimer.start()
	if Input.is_action_just_released("soft_drop"):
		$MoveTimer.wait_time = drop_timer
	if Input.is_action_just_pressed("hard_drop"):
		pc_hard_drop()


func _on_piece_locked():
	spawn_block()

func _on_move_timer_timeout():
	if !pc_move(Vector4i(0,-1,0,0)):
		pc_lock()
