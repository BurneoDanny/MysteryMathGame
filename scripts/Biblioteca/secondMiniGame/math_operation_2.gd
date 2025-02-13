extends Node

@onready var math_label = $MathLabel
@onready var health_timer = $"../../CanvasLayer3/Control"
@onready var win_screen = $"../../CanvasLayer4/WinScreen"
@onready var game_elements = $"../.."

var math_operations = [
	# Operaciones para 455
	{"question": "350 + 105", "answer": 455},
	{"question": "500 - 45", "answer": 455},

	# Operaciones para 789
	{"question": "600 + 189", "answer": 789},
	{"question": "850 - 61", "answer": 789},

	# Operaciones para 994
	{"question": "497 + 497", "answer": 994},
	{"question": "1000 - 6", "answer": 994},
	{"question": "1988 ÷ 2", "answer": 994},
]

var correct_answer = 0  # Respuesta correcta actual
var correct_count = 0  # Contador de respuestas correctas
var game_paused = false  # Estado del juego

func _ready():
	generate_new_math_problem()
	win_screen.hide()  # Oculta la pantalla de victoria al inicio

func _process(delta):
	if game_paused:
		return  # Si el juego está pausado, no hacer nada

func generate_new_math_problem():
	if game_paused or math_operations.size() == 0:
		return  # No generar nuevas preguntas si el juego está pausado o si ya no hay más preguntas

	var random_index = randi() % math_operations.size()
	var selected_operation = math_operations[random_index]

	math_label.text = selected_operation["question"]
	correct_answer = selected_operation["answer"]

func check_answer(player_answer):
	if game_paused:
		return  # Evita procesar respuestas cuando el juego está pausado

	if player_answer == correct_answer:
		math_label.text = "¡Correcto!"
		correct_count += 1
		print_debug("Veces correctas: ", correct_count)

		# Eliminar la operación correcta del array
		math_operations = math_operations.filter(func(op): return op["answer"] != player_answer)

		if correct_count >= 3 or math_operations.size() == 0:
			show_win_screen()  # Pausar el juego y mostrar la ventana de victoria
			return  # Detener la ejecución aquí para evitar generar otra pregunta
		
		await get_tree().create_timer(1).timeout  # Esperar 1 segundo
		generate_new_math_problem()
	else:
		math_label.text = "Incorrecto"
		if health_timer:
			health_timer.subtract_time(10)
		else:
			print_debug("No se pudo acceder a health_timer.gd")
		await get_tree().create_timer(1).timeout  # Esperar 1 segundo
		generate_new_math_problem()

func show_win_screen():
	print_debug("Mostrando pantalla de victoria...")
	game_paused = true  # Pausar el juego

	# Deshabilitar los elementos del juego sin pausar WinScreen
	for node in game_elements.get_children():
		if node != win_screen:
			if node is Timer:
				node.stop()
			elif node is Control or node is SubViewportContainer:
				node.visible = false  # Ocultar elementos innecesarios
			else:
				node.process_mode = Node.PROCESS_MODE_DISABLED  # Deshabilitar lógica de juego

	# Asegurar que WinScreen sigue funcionando
	win_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	win_screen.show_win_screen()  # Llama a la función en WinScreen

	# Asegurar que la UI de WinScreen está en la capa más alta
	if win_screen.get_parent() is CanvasLayer:
		win_screen.get_parent().layer = 100  # Eleva WinScreen sobre todo
