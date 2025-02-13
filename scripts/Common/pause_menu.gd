extends Control

func _ready():
	$AnimationPlayer.play("RESET")  # Asegura que la animación inicie en el estado correcto

func resume():	
	get_tree().paused = false
	$AnimationPlayer.play("blur")
	self.visible = false  # Oculta la ventana de pausa

func pause():
	self.visible = true  # Asegura que la ventana de pausa esté visible
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

func _on_continuar_pressed() -> void:
	resume()

func _on_reiniciar_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_salir_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Common/TileMap.tscn")

func _process(delta):
	testEsc()
