extends CharacterBody3D

signal locked

func _physics_process(delta):
	if Input.is_action_just_pressed("move_x-"):
		move_and_collide(Vector3(-1,0,0))
	if Input.is_action_just_pressed("move_x+"):
		move_and_collide(Vector3(1,0,0))
	if Input.is_action_just_pressed("move_z-"):
		move_and_collide(Vector3(0,0,-1))
	if Input.is_action_just_pressed("move_z+"):
		move_and_collide(Vector3(0,0,1))
		
func _on_timer_timeout():
	var collision = move_and_collide(Vector3(0,-1,0))
	if collision != null: locked.emit()
	
