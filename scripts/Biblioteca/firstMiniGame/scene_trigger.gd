class_name SceneTrigger extends Area2D

# Variable exportada que permite seleccionar la escena a cargar desde el editor
@export var connected_scene: String

# Carpeta base donde están las escenas
var scene_folder: String = "res://scenes/Biblioteca/firstMiniGame/"

# Método que se ejecuta cuando un cuerpo entra en el área
func _on_body_entered(body):
	# Construye la ruta completa a la escena basada en la carpeta y el nombre especificado
	var full_path: String = scene_folder + connected_scene + ".tscn"
	# Obtiene el árbol de escenas actual
	var scene_tree = get_tree()
	# Cambia a la nueva escena especificada
	scene_tree.call_deferred("change_scene_to_file",full_path)
