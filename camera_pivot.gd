extends Marker3D

const MAIN_BUTTONS = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT | MOUSE_BUTTON_MASK_MIDDLE
const ROT_SPEED = .02

var initial_rot_y

func _ready():
	initial_rot_y = rotation.y
	transform.basis = Basis.from_euler(Vector3(rotation.x, initial_rot_y, rotation.z))
	set_physics_process(false)

func _physics_process(delta: float):
	transform.basis = Basis.from_euler(Vector3(rotation.x, rotation.y - (rotation.y - initial_rot_y)/10, rotation.z))
	if absf(rotation.y - initial_rot_y) < 0.01:
		rotation.y = initial_rot_y
		set_physics_process(false)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion && event.button_mask & MAIN_BUTTONS:
		set_physics_process(false)
		var relative_motion: Vector2 = event.screen_relative
		transform.basis = Basis.from_euler(Vector3(rotation.x, rotation.y - relative_motion.x * ROT_SPEED, rotation.z))
	elif event is InputEventMouseButton && !event.button_mask && rotation.y != initial_rot_y:
		set_physics_process(true)
