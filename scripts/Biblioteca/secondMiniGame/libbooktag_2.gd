extends "res://scripts/Biblioteca/secondMiniGame/ClickableSprite.gd"

const book_tag_number = 789  # Cambia este número según el sprite

@onready var math_operation = null

func _ready():
	# Intenta obtener el nodo por su grupo primero
	math_operation = $"../CanvasLayer2/MathOperation"
	
	# Si no lo encuentra, intenta obtenerlo directamente por su ruta
	if math_operation == null:
		math_operation = get_node_or_null("CanvasLayer2/MathOperation")

	# Depuración
	if math_operation:
		print("MathOperation encontrado:", math_operation)
	else:
		print_debug("Error: No se encontró MathOperation en el grupo ni en la ruta")

func on_click():
	modulate = Color(randf(), randf(), randf())  # Cambia el color aleatoriamente
	print("Número seleccionado:", book_tag_number)

	if math_operation:
		math_operation.check_answer(book_tag_number)
	else:
		print_debug("No se encontró el nodo math_operation")
