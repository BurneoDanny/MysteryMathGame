extends Node

@onready var math_label = $MathLabel
@onready var health_timer = $"../../CanvasLayer/timer"
@onready var win_screen = $"../../CanvasLayer4/WinScreen"
@onready var game_elements = $"../.."

var math_operations = [
	{"question": "30 + 27", "answer": 57},
	{"question": "100 - 43", "answer": 57},

	{"question": "184 + 184", "answer": 368},
	{"question": "400 - 32", "answer": 368},

	{"question": "231 + 232", "answer": 463},
	{"question": "500 - 37", "answer": 463},

	{"question": "326 + 327", "answer": 653},
	{"question": "1306 ÷ 2", "answer": 653},

	{"question": "50 + 48", "answer": 98},
	{"question": "120 - 22", "answer": 98},

	{"question": "40 + 20", "answer": 60},
	{"question": "100 - 40", "answer": 60},
]

var correct_answer = 0  # Respuesta correcta actual
var correct_count = 0  # Contador de respuestas correctas

func _ready():
	generate_new_math_problem()
	win_screen.hide()  # Oculta la pantalla de victoria al inicio

func generate_new_math_problem():
	# Verificar si quedan operaciones disponibles
	if math_operations.size() == 0:
		show_win_screen()
		return

	# Elegir una operación aleatoria
	var random_index = randi() % math_operations.size()
	var selected_operation = math_operations[random_index]

	# Asignar la pregunta y la respuesta correcta
	math_label.text = selected_operation["question"]
	correct_answer = selected_operation["answer"]

func check_answer(player_answer):
	if player_answer == correct_answer:
		math_label.text = "¡Correcto!"
		correct_count += 1
		print_debug("Veces correctas: ", correct_count)

		# Eliminar la operación correcta del array
		math_operations = math_operations.filter(func(op): return op["answer"] != player_answer)

		# Verificar si ganó
		if correct_count >= 3 or math_operations.size() == 0:
			show_win_screen()
			return

		await get_tree().create_timer(1).timeout  # Esperar 1 segundo
		generate_new_math_problem()  # Nueva operación
		return true
	else:
		math_label.text = "Incorrecto"
		if health_timer:
			health_timer.subtract_time(10)  # Llama a la función en health_timer.gd
		else:
			print_debug("No se pudo acceder a health_timer.gd")

		await get_tree().create_timer(1).timeout  # Esperar 1 segundo
		generate_new_math_problem()  # Nueva operación
		return false	

func disable_game():
	for node in game_elements.get_children():
		if node != win_screen:
			if node is Timer:
				node.stop()
			elif node is AnimationPlayer:
				node.stop()
			elif node is Control or node is SubViewportContainer:
				node.visible = false
			else:
				node.process_mode = Node.PROCESS_MODE_DISABLED

func show_win_screen():
	print_debug("Mostrando pantalla de victoria...")

	# Deshabilitar los elementos del juego sin pausar WinScreen
	for node in game_elements.get_children():
		if node != win_screen:
			if node is Timer:
				node.stop()
			elif node is AnimationPlayer:
				node.stop()
			elif node is Control or node is SubViewportContainer:
				node.visible = false
			else:
				node.process_mode = Node.PROCESS_MODE_DISABLED

	# Asegurar que WinScreen sigue funcionando
	win_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	win_screen.show_win_screen()  # Llama a la función en WinScreen

	# Asegurar que la UI de WinScreen está en la capa más alta
	if win_screen.get_parent() is CanvasLayer:
		win_screen.get_parent().layer = 100  # Eleva WinScreen sobre todo
