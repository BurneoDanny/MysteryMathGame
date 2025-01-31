extends Node2D

var initial_positions = {}
var assigned_numbers = []
@onready var time_panel = $timerlabel

func _ready() -> void:
	save_initial_positions()
	assign_numbers()
	generate_numbers()
	update_level_label()
	$Timer.start()

func _process(delta: float) -> void:
	update_timer_label()
	
func reset_for_next_level() -> void:
	GameState.current_level += 1
	if GameState.current_level >= 2 && GameState.current_level <= 5:
		play_move_animation(GameState.current_level)
	restore_initial_positions()	
	assign_numbers()
	generate_numbers()
	update_level_label()
	$Timer.start()
	

func save_initial_positions() -> void:
	var objects = get_tree().get_nodes_in_group("draggable_object")
	var dropzones = get_tree().get_nodes_in_group("dropzone")
	for obj in objects:
		initial_positions[obj] = obj.global_position
	for zone in dropzones:
		initial_positions[zone] = zone.global_position


func restore_initial_positions() -> void:
	var objects = get_tree().get_nodes_in_group("draggable_object")
	var dropzones = get_tree().get_nodes_in_group("dropzone")
	
	# Restaurar objetos
	for obj in objects:
		if obj in initial_positions:
			obj.global_position = initial_positions[obj]  # Restaurar posición inicial
		obj.set("assigned_number", 0)  # Reiniciar número asignado
		obj.set("placed_in_dropzone", false)  # Marcar como no colocado
		obj.set("draggable", false)  # Reiniciar draggable
	
	# Restaurar zonas
	for zone in dropzones:
		if zone in initial_positions:
			zone.global_position = initial_positions[zone]  # Restaurar posición inicial
		zone.set("zone_number", 0)  # Reiniciar número de zona
		zone.set("is_occupied", false)  # Marcar como no ocupada
		zone.modulate = Color(Color.WHITE)  # Restaurar color original

func assign_numbers() -> void:
	assigned_numbers = []
	while assigned_numbers.size() < 6:
		var random_number = randi_range(1, 999)
		if random_number not in assigned_numbers:
			assigned_numbers.append(random_number)
			
func generate_numbers() -> void:
	var objects = get_tree().get_nodes_in_group("draggable_object")
	var dropzones = get_tree().get_nodes_in_group("dropzone")
	
	objects = shuffle_nodes(objects)
	dropzones = shuffle_nodes(dropzones)
	
	for i in range(assigned_numbers.size()):
		var number = assigned_numbers[i]
		if i < objects.size():
			objects[i].set("assigned_number", number)
			var label = objects[i].get_node("Label")
			if label:
				label.text = str(number)

		if i < dropzones.size():
			dropzones[i].set("zone_number", number)
			var label = dropzones[i].get_node("Label")
			if label:
				label.text = str(convert_number_to_words(number))

func shuffle_nodes(nodes: Array) -> Array:
	for i in range(nodes.size()):
		var random_index = randi_range(0, nodes.size() - 1)
		var temp = nodes[i]
		nodes[i] = nodes[random_index]
		nodes[random_index] = temp
	return nodes	
	
func convert_number_to_words(number: int) -> String:
	var units = ["", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve"]
	var teens = ["diez", "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve"]
	var tens = ["", "", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"]
	var hundreds = ["", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"]

	if number == 0:
		return "cero"
	if number == 100:
		return "cien"

	var words = ""
	var hundreds_digit = number / 100
	var tens_digit = (number % 100) / 10
	var units_digit = number % 10

	if hundreds_digit > 0:
		words += hundreds[hundreds_digit] + " "

	if tens_digit == 1:
		words += teens[units_digit]
		return words.strip_edges()

	if tens_digit > 1:
		words += tens[tens_digit]
		if units_digit > 0:
			words += " y " + units[units_digit]
		return words.strip_edges()

	if units_digit > 0:
		words += units[units_digit]

	return words.strip_edges()

func update_timer_label() -> void:
	var time_left = $Timer.time_left 
	var minutes = int(time_left) / 60  
	var seconds = int(time_left) % 60 
	time_panel.text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2)  
	if time_left <= 15:
		time_panel.modulate = Color(1, 0, 0)
	else:
		time_panel.modulate = Color(1, 1, 1) 
	
func _on_timer_timeout() -> void:
	restore_initial_positions()	
	assign_numbers()
	generate_numbers()
	update_level_label()
	$Timer.start()

func play_move_animation(level: int) -> void:
	var animation_name = "move_" + str(level)
	var subviewport = $"Container/SubViewport"
	if subviewport:
		var scene_3d = subviewport.get_node("Biblioteca3d")
		if scene_3d:
				var animation_player = scene_3d.get_node("AnimationPlayer")
				if animation_player:
					$objects.visible = false
					$zones.visible = false
					$Fondo.modulate = Color(1, 1, 1, 1)  # Totalmente opaco
					animation_player.play(animation_name)
					animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
				else:
					print("No se encontró el AnimationPlayer.")
		else:
			print("No se encontró la escena 3D dentro del SubViewport.")
	else:
		print("No se encontró el SubViewport.")

# Función para manejar el evento cuando la animación termina
func _on_animation_finished(anim_name: String) -> void:
	if anim_name.begins_with("move_"):
		$Fondo.modulate = Color(1, 1, 1, 0.5) 
		$objects.visible = true
		$zones.visible = true


func update_level_label() -> void:
	var level_label = $level
	if level_label:
		level_label.text = "Nivel: " + str(GameState.current_level)
