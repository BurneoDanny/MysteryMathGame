extends Sprite2D

# Señal para cuando el sprite es clickeado
signal clicked

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			emit_signal("clicked")  # Emite la señal cuando el sprite es clickeado
			on_click()

# Función virtual para que los hijos la sobreescriban
func on_click():
	print("Sprite clicked! Override this method in child classes.")
