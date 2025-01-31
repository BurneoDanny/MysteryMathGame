extends Node2D

@onready var mayor: Sprite2D = $mayor
@onready var player: CharacterBody2D = $player

func _ready() -> void:
	if GameState.library_completed:
		library_completed() 
	else:
		introduce_dialogue() 

func introduce_dialogue() -> void:
	mayor.visible = true
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/welcoming.dialogue"), "start")

func _on_main_dialogue_finished() -> void:
	player.can_move = true
	mayor.visible = false

func library_completed() -> void:
	mayor.visible = true
	player.can_move = false
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/library_finished.dialogue"), "start")

func _on_library_mystery_finished() -> void:
	player.can_move = true
	mayor.visible = false
