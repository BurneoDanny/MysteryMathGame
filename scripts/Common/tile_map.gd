extends Node2D

@onready var mayor: Sprite2D = $mayor

func _ready() -> void:
	introduce_dialogue() 

func introduce_dialogue() -> void:
	mayor.visible = true
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/welcoming.dialogue"), "start")

func _on_main_dialogue_finished() -> void:
	mayor.visible = false
	var player = get_tree().get_nodes_in_group("player")[0]  # 🔹 Encuentra al personaje (asegúrate de que está en el grupo "player")
	player.can_move = true  # 🔹 Ahora el jugador puede moverse
