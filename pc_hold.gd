extends CanvasItem

var hold

func _ready():
	hold = get_parent().get_child(0).get_child(0)

func _draw():
	if Autoload.hold:
		draw_texture(Autoload.hold.preview,
		Vector2(hold.position.x + 40 - Autoload.hold.preview.get_width()/2,
		hold.position.y + 40 - Autoload.hold.preview.get_height()/2))

func _on_pc_spawner_held():
	queue_redraw()
