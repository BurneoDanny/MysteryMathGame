extends "res://scripts/Common/gameover.gd"

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Biblioteca/firstMiniGame/inside_library.tscn")
