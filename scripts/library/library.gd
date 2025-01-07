extends Node2D

var book = preload('res://scenes/library/thirdMiniGame/draggableObject.tscn')
var dropzone = preload('res://scenes/library/thirdMiniGame/dropzone.tscn')

@onready var books_grid = $Control/BooksGrid
@onready var drop_grid = $Control/DropGrid

var min_books = 4
var max_books = 8

func _ready() -> void:
	var num_books = randi_range(min_books / 2, max_books / 2) * 2
	generate_books_and_zones(num_books)

func generate_books_and_zones(num_books: int) -> void:

	for i in range(num_books):
		var random_number = randi_range(1, 999)
		var number_in_words = convert_number_to_words(random_number)  # Convertir a texto
		
		var book_instance = book.instantiate()
		var wrapper = Control.new()
		wrapper.custom_minimum_size = Vector2(100, 150)
		
		# Asignar texto en español al Label existente
		var number_label = book_instance.get_node("Label")  # Asegúrate de que "Label" sea el nombre del nodo en tu escena
		if number_label:
			number_label.text = str(random_number)	
		wrapper.add_child(book_instance)
		
		# Añadir el wrapper al GridContainer
		books_grid.add_child(wrapper)
		print("Book added to grid with number in words:", number_in_words)

		var dropzone_instance = dropzone.instantiate()
		var drop_wrapper = Control.new()  # Crear un nodo `Control` que actuará como contenedor
		drop_wrapper.custom_minimum_size = Vector2(100, 150)
		var drop_number_label = dropzone_instance.get_node("Label")  # Asegúrate de que "Label" sea el nombre del nodo en tu escena
		if drop_number_label:
			drop_number_label.text = number_in_words
		drop_wrapper.add_child(dropzone_instance)
		drop_grid.add_child(drop_wrapper)  # Añadir el wrapper al GridContainer
		print("Dropzone added to grid with number in words:", number_in_words)

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
