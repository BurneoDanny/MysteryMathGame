extends Control

func _on_play_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/Biblioteca/thirdMiniGame/thirdminigame.tscn")
	#SceneTransition.change_scene("res://scenes/Biblioteca/secondMiniGame/minigame_2.tscn")
	get_tree().change_scene_to_file("res://scenes/Common/TileMap.tscn")

func _on_options_pressed() -> void:
	SceneTransition.change_scene("res://scenes/Common/OptionsMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()	
