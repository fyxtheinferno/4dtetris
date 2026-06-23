extends Label
var score = 0
var score_incr = {
	1: 100,
	2: 300,
	3: 500,
	4: 800
}

func _on_pc_spawner_cleared(mult):
	score += score_incr[mult]
	text = "Score: %s" % score
