extends Control

func _ready():
	hide()


func _on_pc_spawner_game_over() -> void:
	show()
