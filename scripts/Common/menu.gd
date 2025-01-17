extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Biblioteca/thirdMiniGame/minigame.tscn")

func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Common/OptionsMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()	
