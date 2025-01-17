extends Control



func _on_volume_pressed() -> void:
	print("volumen 100%")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Common/menu.tscn")
