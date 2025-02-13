extends Node

@onready var label = $Label
@onready var timer = $Timer
@onready var animation = $Label/AnimationPlayer
@onready var animation_timer = $animation_timer
@onready var game_over_screen = $"../../CanvasLayer5/GameOver"

func _ready():
	timer.start()
	animation.play("RESET")
	
	# 🔄 Esperar un frame para asegurar que GameOver se haya cargado
	await get_tree().process_frame
	
	# 🔍 Verificar si GameOver existe antes de usarlo
	if game_over_screen:
		game_over_screen.hide()  # Ocultar GameOver al inicio
	else:
		print_debug("⚠️ Advertencia: No se encontró el nodo GameOver en CanvasLayer4")

func time_left_to_live():
	var time_left = timer.time_left
	var minute = floor(time_left) / 60
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta):
	label.text = "%02d:%02d" % time_left_to_live()

	# ✅ Si el tiempo llega a 0, mostrar GameOver
	if timer.time_left <= 0:
		show_game_over()

func subtract_time(seconds: int):
	var new_time = max(0, timer.time_left - seconds)  # Asegura que el tiempo no sea negativo
	timer.start(new_time)
	animation.play("blink")
	animation_timer.start()
	await animation_timer.timeout
	animation.play("RESET")
	print_debug("⏳ Tiempo restante después de restar:", timer.time_left)

	# ✅ Si el tiempo llega a 0 tras restar, mostrar GameOver
	if new_time == 0:
		show_game_over()

func show_game_over():
	print_debug("⌛ Tiempo agotado. Mostrando pantalla de Game Over...")

	# 🔍 Verificar que el nodo GameOver existe
	if game_over_screen == null:
		print_debug("⚠️ Error: GameOver no se encontró en CanvasLayer5")
		return

	# ✅ Asegurar que la pantalla de GameOver es visible antes de pausar el juego
	game_over_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	game_over_screen.show_game_over()  # Llamamos correctamente a la función
	
	await get_tree().process_frame  # 🔄 Espera un frame para actualizar la UI

	# 🔥 Ahora sí, pausar el juego
	get_tree().paused = true
