extends Node2D

@onready var dialogue_manager = $DialogueManager  # Asegúrate de que tienes un nodo de diálogo

func _ready() -> void:
	start_dialogue()  # Llamamos la función para iniciar el diálogo

func start_dialogue() -> void:
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/welcoming.dialogue"), "start")
