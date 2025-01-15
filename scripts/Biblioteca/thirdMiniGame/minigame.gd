extends Node2D

var assigned_numbers = []


func _ready() -> void:
	assign_numbers()
	generate_numbers()
	
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

# Función para convertir números a texto en español
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
