extends Node2D

@onready var librerian: Sprite2D = $librerian

# Called when the node enters the scene tree for the first time.
func _ready():
	introduce_dialogue()

func introduce_dialogue() -> void:
	librerian.visible = true
	DialogueManager.show_example_dialogue_balloon(load("res://dialogues/b_minigame2.dialogue"), "start")

func _on_lupa_dialogue_finished() -> void:
	librerian.visible = false
	
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SceneTransition.change_scene("res://scenes/Biblioteca/thirdMiniGame/thirdminigame.tscn")
