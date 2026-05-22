extends MeshInstance3D

@export var offset: Vector3

var surface_array: Array = []
var cube_vertices: Array[Vector3]
var vertices = PackedVector3Array()
var normals = PackedVector3Array()
var colors = PackedColorArray()

enum Face{BOTTOM, FRONT, RIGHT, TOP, LEFT, BACK}

var face_indices: Dictionary[Face, Array] = {
	Face.BOTTOM: [[0,4,2], [2,4,6]],
	Face.FRONT: [[0,1,5], [5,4,0]],
	Face.RIGHT: [[5,7,4], [7,6,4]],
	Face.TOP: [[1,3,7], [7,5,1]],
	Face.LEFT: [[3,1,0], [0,2,3]],
	Face.BACK: [[7,3,6], [6,3,2]]
}

var face_normals: Dictionary[Face, Vector3] = {
	Face.BOTTOM: Vector3(0,-1,0),
	Face.FRONT: Vector3(0,0,1),
	Face.RIGHT: Vector3(1,0,0),
	Face.TOP: Vector3(0,1,0),
	Face.LEFT: Vector3(-1,0,0),
	Face.BACK: Vector3(0,0,-1)
}

var face_colors: Dictionary[Face,Color] = {
	Face.BOTTOM: Color.RED,
	Face.FRONT: Color.ORANGE,
	Face.RIGHT: Color.YELLOW,
	Face.TOP: Color.GREEN,
	Face.LEFT: Color.BLUE,
	Face.BACK: Color.PURPLE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	cube_vertices = [
		Vector3(0,0,0) + offset,
		Vector3(0,0,1) + offset,
		Vector3(0,1,0) + offset,
		Vector3(0,1,1) + offset,
		Vector3(1,0,0) + offset,
		Vector3(1,0,1) + offset,
		Vector3(1,1,0) + offset,
		Vector3(1,1,1) + offset,
	]
	
	surface_array.resize(Mesh.ARRAY_MAX)
	generate_mesh()

func generate_mesh() -> void:
	add_face(Face.FRONT, Vector3.ZERO)
	add_face(Face.BACK, Vector3.ZERO)
	add_face(Face.BOTTOM, Vector3.ZERO)
	add_face(Face.TOP, Vector3.ZERO)
	add_face(Face.LEFT, Vector3.ZERO)
	add_face(Face.RIGHT, Vector3.ZERO)
	commit_mesh()
	

func add_face(face: Face, position: Vector3) -> void:
		var indices = face_indices[face]
		for triangle in indices:
			for index in triangle:
				vertices.append(cube_vertices[index] + position)
				normals.append(face_normals[face])

func commit_mesh() -> void:
	surface_array[Mesh.ARRAY_VERTEX] = vertices
	surface_array[Mesh.ARRAY_NORMAL] = normals
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)	
	
