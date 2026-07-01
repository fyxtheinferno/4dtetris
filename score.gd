extends Label
var score = 0
var hiscore
var score_incr = {
	1: 1000,
	2: 3000,
	3: 5000,
	4: 8000
}

func _ready():
	var file = FileAccess.open("user://save.txt", FileAccess.READ)
	if file:
		hiscore = file.get_as_text().strip_edges().to_int()
		file.close()
	else:
		hiscore = 0
	text = "Score: 0\nHiscore: %s" % hiscore
func _on_pc_spawner_cleared(mult):
	score += score_incr[mult]
	if score > hiscore:
		text = "Score: %s\n Hiscore: %s" % [score, score]
	else:
		text = "Score: %s\nHiscore: %s" % [score, hiscore]

func _on_pc_spawner_game_over():
	if score > hiscore:
		var file = FileAccess.open("user://save.txt", FileAccess.WRITE)
		file.store_string(str(score))
