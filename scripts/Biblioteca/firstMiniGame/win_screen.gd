extends "res://scripts/Common/BaseWinScreen.gd"

# Puedes sobrescribir funciones si necesitas cambios específicos para un minijuego
func _on_continuar_pressed():
	print("Continuar presionado en este minijuego")
	close_win_screen()
	get_tree().change_scene_to_file("res://scenes/Biblioteca/secondMiniGame/minigame_3.tscn")
