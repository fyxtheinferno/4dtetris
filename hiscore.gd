extends Label

func _ready() -> void:
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	if file:
		text = "Hiscore: %s" %file.get_as_text().strip_edges().to_int()
		file.close()
