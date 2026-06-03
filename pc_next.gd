extends CanvasItem

var next

func _ready():
	next = get_parent().get_child(1).get_child(0)

func _draw():
	for i in 6:
		draw_texture(Autoload.pc_queue[i].preview,
			Vector2(next.position.x + 40 - Autoload.pc_queue[i].preview.get_width()/2,
			next.position.y + 80*i + 40 - Autoload.pc_queue[i].preview.get_height()/2))

func _on_pc_spawner_spawned():
	queue_redraw()
