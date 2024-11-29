extends Node2D

var book = preload('res://scenes/library/thirdMiniGame/draggableObject.tscn')
var dropzone = preload('res://scenes/library/thirdMiniGame/dropzone.tscn')

@onready var books_grid = $BooksGrid
@onready var drop_grid = $DropGrid

var min_books = 4
var max_books = 12

func _ready() -> void:
	var num_books = randi_range(min_books / 2, max_books / 2) * 2
	generate_books_and_zones(num_books)

func generate_books_and_zones(num_books: int) -> void:
	var spacing = 100
	for i in range(num_books):
		var book_instance = book.instantiate()
		var wrapper = Control.new()  # Crear un nodo padre compatible
		wrapper.add_child(book_instance)  # Agregar el libro al wrapper
		books_grid.add_child(wrapper)
		print("Book position: ", book_instance.position)

	for i in range(num_books):
		var dropzone_instance = dropzone.instantiate()
		var wrapper = Control.new()  # Crear un nodo padre compatible
		wrapper.add_child(dropzone_instance)  # Agregar el libro al wrapper
		drop_grid.add_child(wrapper)
		print("Dropzone position: ", dropzone_instance.position)

	
