extends Sprite2D

func _ready() -> void:
	modulate = Color(Color.WHITE, 0.7)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		get_tree().reload_current_scene()
