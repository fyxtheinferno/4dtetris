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


	#TODO
	#if Input.is_action_just_pressed("soft_drop"):
		#tmp_wait_time = $MoveTimer.wait_time
		#move_and_collide(Vector3(0,-1,0))
		#$MoveTimer.wait_time /= 10
	#elif Input.is_action_just_released("soft_drop"):
		#$MoveTimer.wait_time = tmp_wait_time
	
	if Input.is_action_just_pressed("hard_drop"):
		global_position.y -= global_position.y-0.5-roundi($BelowDetector.get_collision_point().y) 
		lock_piece()

func lock_piece():
	set_physics_process(false)
	$Timers/MoveTimer.stop()
	locked.emit()

func _on_timer_timeout():
	var collision = move_and_collide(Vector3(0,-1,0))
	if collision != null:
		print(collision)
		#start a timer
		#timer resets each time the piece is rotated / moved (but only to a point)
		#timer is null if the piece is moved off solid ground
		#once the timer expires: replace the piece with corresponding block terrain
		lock_piece()	
