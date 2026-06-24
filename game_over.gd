extends Control

func _ready():
	hide()


func _on_pc_spawner_game_over() -> void:
	show()
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and visible:
		# This restarts the current scene.
		get_tree().reload_current_scene()
