extends Sprite2D

@onready var minigame = $".."

func _ready() -> void:
	modulate = Color(Color.WHITE, 0.7)
	var objects = get_tree().get_nodes_in_group("draggable_object")
	for obj in objects:
		obj.connect("placement_changed", Callable(self, "_on_placement_changed"))

func _on_placement_changed() -> void:
	update_arrow_visibility()		

func update_arrow_visibility() -> void:
	if all_books_in_place():
		$"../Timer".stop()
		modulate = Color(Color.WHITE, 1)
	else:
		modulate = Color(Color.WHITE, 0.7) 
	
# Verifica si todos los objetos están en las zonas correctas
func all_books_in_place() -> bool:
	var objects = get_tree().get_nodes_in_group("draggable_object")
	for obj in objects:
		if not obj.placed_in_dropzone:
			return false
	return true	
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if all_books_in_place():
			if GameState.current_level < GameState.max_levels:
				minigame.reset_for_next_level()
			else:
				print("¡Has completado todos los niveles!")
		else:
			print("Todos los libros deben estar en las zonas correctas antes de continuar.")
