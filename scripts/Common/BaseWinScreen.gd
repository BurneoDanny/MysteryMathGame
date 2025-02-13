extends Control

# Señal para cuando se cierre el WinScreen y el juego deba reanudarse
signal win_screen_closed

func _ready():
	$AnimationPlayer.play("RESET")
	hide()  # Oculta la pantalla de victoria al inicio

func show_win_screen():
	$AnimationPlayer.play("blur")  # Reproduce la animación
	await $AnimationPlayer.animation_finished  # Espera a que termine la animación
	show()  # Muestra la ventana de victoria

# Función para cerrar la pantalla de victoria y emitir la señal
func close_win_screen():
	hide()
	emit_signal("win_screen_closed")

func _on_continuar_pressed() -> void:
	close_win_screen()
	get_tree().change_scene_to_file("res://scenes/Common/TileMap.tscn")

func _on_reiniciar_pressed() -> void:
	close_win_screen()
	get_tree().reload_current_scene()

func _on_salir_pressed() -> void:
	close_win_screen()
	get_tree().change_scene_to_file("res://scenes/Common/TileMap.tscn")
