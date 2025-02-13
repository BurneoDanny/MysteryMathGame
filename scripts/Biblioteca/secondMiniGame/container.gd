extends SubViewportContainer

func _ready():
	pass  # Replace with function body.

func _process(delta):
	var pos = get_tree().get_current_scene().get_global_mouse_position()
	$SubViewport/Camera2D.global_position = pos

	pos.x -= 50
	pos.y -= 50
	global_position = pos
