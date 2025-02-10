extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	audio_stream_player.play()

func _on_play_pressed() -> void:
	#SceneTransition.change_scene("res://scenes/Biblioteca/thirdMiniGame/thirdminigame.tscn")
	SceneTransition.change_scene("res://scenes/Biblioteca/secondMiniGame/minigame_2.tscn")
	#SceneTransition.change_scene("res://scenes/Common/TileMap.tscn")

func _on_options_pressed() -> void:
	SceneTransition.change_scene("res://scenes/Common/OptionsMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()	
