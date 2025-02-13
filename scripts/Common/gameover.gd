extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	hide()  # Oculta la pantalla de GameOver al inicio
	self.visible = false  # Asegura que GameOver esté oculto al inicio
	self.process_mode = Node.PROCESS_MODE_ALWAYS  # Asegura que siga funcionando

func show_game_over():
	print_debug("⌛ Ejecutando animación de GameOver...")

	self.process_mode = Node.PROCESS_MODE_ALWAYS  # Asegura que siga funcionando
	self.visible = true  # Asegura que se muestre
	show()  # Muestra la ventana de GameOver antes de la animación
	
	$AnimationPlayer.play("blur")  # Reproduce la animación
	
	await $AnimationPlayer.animation_finished  # Espera a que termine la animación
	print_debug("✅ GameOver mostrado correctamente.")

func _on_reiniciar_pressed() -> void:
	get_tree().paused = false  #  Despausa el juego antes de reiniciar
	get_tree().reload_current_scene()  # Recarga la escena

func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Common/TileMap.tscn")
