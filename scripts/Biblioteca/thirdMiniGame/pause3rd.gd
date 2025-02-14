extends Control
@onready var timer: Timer = $"../Timer"

func _on_continuar_pressed() -> void:
	get_tree().paused = false 
	self.visible = false
	timer.start()

func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Common/TileMap.tscn")
