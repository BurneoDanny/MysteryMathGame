extends CharacterBody2D 

const speed = 200
var current_dir = "none"
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer
@export var knockbackPower: int = 2000
@export var maxHealth = 3
@onready var currentHealth: int = maxHealth
@onready var hurtBox = $hurtbox
@onready var game_over_screen = $"../CanvasLayer5/GameOver"
@onready var game_elements = $"../.."  # Todos los elementos del juego para pausarlos
signal healthChanged
var isHurt: bool = false

func _ready():
	$AnimatedSprite2D.play("front_idle")
	effects.play("RESET")

	if game_over_screen:  # 🔥 Evita el error si es nulo
		game_over_screen.hide()  # Ocultar GameOver al inicio
	else:
		print_debug("⚠ ERROR: No se encontró game_over_screen")

func handle_collision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		print_debug(collider.name)

func _physics_process(delta):
	player_movement(delta)
	handle_collision()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitbox":
				hurtByEnemy(area)
			
func hurtByEnemy(area):
	currentHealth -= 1
	healthChanged.emit(currentHealth)

	if currentHealth <= 0:
		show_game_over()  # Llama a la función para pausar y mostrar GameOver
		return

	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func player_movement(delta):
	var input_vector = Vector2.ZERO  # Vector para almacenar el movimiento

	# Captura la dirección de movimiento en X e Y
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	# Normalizar para evitar que la velocidad diagonal sea mayor
	input_vector = input_vector.normalized()

	# Aplicar la velocidad
	velocity = input_vector * speed

	# Manejar animaciones
	if velocity.length() > 0:
		play_anim(1)
		if input_vector.x > 0:
			current_dir = "right"
		elif input_vector.x < 0:
			current_dir = "left"
		elif input_vector.y > 0:
			current_dir = "down"
		elif input_vector.y < 0:
			current_dir = "up"
	else:
		play_anim(0)

	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D

	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")

	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			anim.play("side_idle")

	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			anim.play("front_idle")

	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			anim.play("back_idle")

func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		var math_operation = $"../CanvasLayer2/MathOperation"
		if math_operation:
			var answer = await math_operation.check_answer(area.booknumber)
			if answer:
				area.collect()

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	print_debug("current HEALTH = ",currentHealth)

#  FUNCIÓN PARA MOSTRAR GAME OVER Y PAUSAR EL JUEGO
func show_game_over():
	print_debug("Mostrando pantalla de GameOver...")

	# Pausar la lógica del juego
	for node in game_elements.get_children():
		if node != game_over_screen:
			if node is Timer:
				node.stop()
			elif node is Control or node is SubViewportContainer:
				node.visible = false  # Ocultar elementos innecesarios
			else:
				node.process_mode = Node.PROCESS_MODE_DISABLED  # Deshabilitar lógica de juego

	# Asegurar que `GameOver` sigue funcionando
	game_over_screen.process_mode = Node.PROCESS_MODE_ALWAYS
	game_over_screen.show_game_over() # Llama a la función en GameOver

	# Pausar completamente el juego
	get_tree().paused = true
