extends Node3D

#@export var l_piece: PackedScene
@export var gridmap: GridMap

signal held
signal spawned

var pc_list = [
	Autoload.i_piece,
	Autoload.l_piece,
	Autoload.o_piece,
	Autoload.s_piece,
	Autoload.t_piece,
	Autoload.tower,
	Autoload.tripod
]

var moving: Array[Vector3i] = []

var pc_current: Autoload.Piece

var min_pos_xz = -4
var max_pos_xz = 0
var min_pos_y = -10

const start_offset = Vector3i(-4,8,-4)
func spawn_block():
	moving = []
	#if pc_queue.size < 7: generate 7-bag; add to queue
	if Autoload.pc_queue.size() < 7:
		pc_list.shuffle()
		Autoload.pc_queue.append_array(pc_list)
	for block in Autoload.pc_queue[0].blocks:
		gridmap.set_cell_item((block + start_offset), Autoload.pc_queue[0].type)
		moving.append(block + start_offset)
	pc_current = Autoload.pc_queue[0]
	Autoload.pc_queue.pop_front()
	
	spawned.emit()

func pc_move(mvmt) -> bool:
	var can_move = true
	for block in moving:
		if !is_valid_position(block + mvmt):
			can_move = false
	
	if can_move:
		for i in moving.size():
			gridmap.set_cell_item(moving[i], -1)
			moving[i] += mvmt
		for i in moving.size():
			gridmap.set_cell_item(moving[i], pc_current.type)
	
	return can_move

func is_valid_position(pos) -> bool:
	if pos.x < min_pos_xz || pos.x > max_pos_xz:
		return false
	elif pos.z < min_pos_xz || pos.z > max_pos_xz:
		return false
	elif pos.y < min_pos_y:
		return false
	
	elif pos not in moving && gridmap.get_cell_item(pos) != -1:
		return false
	
	return true

func pc_hold():
	#TODO figure out how to actually return pieces from hold
	#if hold.size() > 0:
		#var tmp = hold
		#var type_tmp = pc_type_hold
		#hold = moving
		#moving = tmp
	#else:
		#hold = moving
		
	Autoload.hold = pc_current
	for i in moving.size():
			gridmap.set_cell_item(moving[i], -1)
	
	held.emit()
	spawn_block()

func clear_line(y):
	var clearable = true
	for x in range(min_pos_xz, max_pos_xz+1):
		for z in range(min_pos_xz, max_pos_xz+1):
			if gridmap.get_cell_item(Vector3i(x,y,z)) == -1:
				clearable = false
	
	if clearable:
		for x in range(min_pos_xz, max_pos_xz+1):
			for z in range(min_pos_xz, max_pos_xz+1):
				gridmap.set_cell_item(Vector3i(x,y,z), -1)
		
		var falling = []
		for block in gridmap.get_used_cells():
			if block.y > y:
				falling.append(block)
		
		if falling.size() > 0:
			falling.sort_custom(func(a,b): return a.y < b.y)
			for block in falling:
				gridmap.set_cell_item(block - Vector3i(0,1,0), gridmap.get_cell_item(block))
				gridmap.set_cell_item(block, -1)
				
func pc_lock():
	#use properties of dictionary to find all unique y coords block is positioned on; clear lines at coords
	var unique_y = {}
	for block in moving:
		unique_y[block.y] = true
	for y in unique_y.keys():
		clear_line(y)
		
	spawn_block()

func _ready():
	spawn_block()

func _process(_delta):
	if Input.is_action_just_pressed("move_x-"):
		pc_move(Vector3i(-1,0,0))
	if Input.is_action_just_pressed("move_x+"):
		pc_move(Vector3i(1,0,0))
	if Input.is_action_just_pressed("move_z-"):
		pc_move(Vector3i(0,0,-1))
	if Input.is_action_just_pressed("move_z+"):
		pc_move(Vector3i(0,0,1))
	if Input.is_action_just_pressed("hold"):
		pc_hold()


func _on_piece_locked():
	spawn_block()

func _on_move_timer_timeout():
	if !pc_move(Vector3i(0,-1,0)):
		pc_lock()
