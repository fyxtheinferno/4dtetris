extends Button
@export var world: PackedScene

func _pressed():
	get_tree().change_scene_to_packed(world)
